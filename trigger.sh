#send and receive
echo "sending message"
aws sns publish --endpoint-url=http://localhost:4566 --topic-arn arn:aws:sns:eu-central-1:000000000000:order-creation-events --message "Hello World" --profile test-profile --region eu-central-1 --output json | cat

echo "receive message"
aws --endpoint-url=http://localhost:4566 sqs receive-message --queue-url http://localhost:4566/000000000000/dummy-queue --profile test-profile --region eu-central-1 --output json | cat