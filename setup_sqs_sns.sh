aws configure set aws_access_key_id "dummy" --profile test-profile
aws configure set aws_secret_access_key "dummy" --profile test-profile
aws configure set region "eu-central-1" --profile test-profile
aws configure set output "table" --profile test-profile

#create topic, queue and subscription
aws --endpoint-url=http://localhost:4566 sns create-topic --name order-creation-events --region eu-central-1 --profile test-profile --output table | cat
aws --endpoint-url=http://localhost:4566 sqs create-queue --queue-name dummy-queue --profile test-profile --region eu-central-1 --output table | cat
aws --endpoint-url=http://localhost:4566 sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:order-creation-events --profile test-profile  --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:dummy-queue --output table | cat

