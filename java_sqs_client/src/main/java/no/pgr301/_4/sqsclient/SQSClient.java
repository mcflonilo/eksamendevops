package no.pgr301._4.sqsclient;

import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;
import software.amazon.awssdk.services.sqs.model.SendMessageResponse;
import software.amazon.awssdk.regions.Region;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SQSClient implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(SQSClient.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        if (args.length != 1) {
            System.out.println("Please provide image prompt");
            System.exit(-1);
        }
        String messageBody = args[0];

        String awsAccessKeyId = System.getenv("AWS_ACCESS_KEY_ID");
        String awsSecretAccessKey = System.getenv("AWS_SECRET_ACCESS_KEY");

        if (awsAccessKeyId == null || awsSecretAccessKey == null) {
            System.out.println("AWS credentials are not set in environment variables");
            System.exit(-1);
        }

        Region region = Region.EU_WEST_1;
        String queueUrl = System.getenv("SQS_QUEUE_URL");

        SqsClient sqsClient = SqsClient.builder()
                .region(region)
                .credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials.create(awsAccessKeyId, awsSecretAccessKey)))
                .build();

        SendMessageRequest sendMessageRequest = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody(messageBody)
                .build();

        SendMessageResponse response = sqsClient.sendMessage(sendMessageRequest);
        System.out.println("Message sent successfully. Message ID: " + response.messageId());
        System.out.println(response.md5OfMessageBody());
    }
}