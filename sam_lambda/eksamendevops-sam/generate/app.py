import json
import base64
import boto3
import random
import os

bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

model_id = "amazon.titan-image-generator-v1"
bucket_name = os.getenv('BUCKET_NAME', 'default-bucket-name')

def lambda_handler(event, context):
    prompt = event['prompt']
    seed = random.randint(0, 2147483647)
    s3_image_path = f"35/titan_{seed}.png"

    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }

    response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
    model_response = json.loads(response["body"].read())
    base64_image_data = model_response["images"][0]
    image_data = base64.b64decode(base64_image_data)

    s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

    return {
        'statusCode': 200,
        'body': json.dumps(f'Image saved to {s3_image_path}')
    }