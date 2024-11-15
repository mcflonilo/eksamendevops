import json
import base64
import boto3
import random
import os

# Initialize clients
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

# Environment variables
model_id = "amazon.titan-image-generator-v1"
bucket_name = os.getenv('BUCKET_NAME', 'default-bucket-name')

def lambda_handler(event, context):
    try:
        # Handle the incoming event
        if isinstance(event.get('body'), str):
            body = json.loads(event['body'])  # Parse JSON string from body
        else:
            body = event.get('body', event)  # Use body as is or fallback to event

        # Validate required key
        if 'prompt' not in body:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': "Missing 'prompt' key in the request."})
            }

        prompt = body['prompt']
        seed = random.randint(0, 2147483647)
        s3_image_path = f"35/titan_{seed}.png"

        # Bedrock request payload
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

        # Call Bedrock model
        response = bedrock_client.invoke_model(
            modelId=model_id, 
            body=json.dumps(native_request)
        )

        # Parse Bedrock response
        model_response = json.loads(response["body"].read())
        if "images" not in model_response or not model_response["images"]:
            return {
                'statusCode': 500,
                'body': json.dumps({'error': "No images returned by the model."})
            }

        # Decode image data
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Upload image to S3
        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'Image saved to {s3_image_path}'})
        }

    except Exception as e:
        # General error handling
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
