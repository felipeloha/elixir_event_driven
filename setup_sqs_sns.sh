PROFILE="localstack-profile"
HOST=localstack
#HOST=localhost
ENDPOINT_URL="http://$HOST:4566"

echo "### downloading utils"
WAITFORIT_VERSION="v2.4.1"
curl -o waitforit -sSL "https://github.com/maxcnunes/waitforit/releases/download/$WAITFORIT_VERSION/waitforit-linux_amd64" && \
    chmod +x waitforit

echo "### waiting for localstack to be ready"
./waitforit -address=$ENDPOINT_URL -timeout=20 -debug
echo "### localstack ready"

echo "### setting up aws configuration"
aws configure set aws_access_key_id "dummy" --profile $PROFILE
aws configure set aws_secret_access_key "dummy" --profile $PROFILE
aws configure set region "eu-central-1" --profile $PROFILE
aws configure set output "table" --profile $PROFILE

export AWS_DEFAULT_PROFILE=$PROFILE

echo "setting up sqs sns and subscription"

echo "########### Setting SQS names as env variables ###########"
SOURCE_SQS="restaurant-queue"
DLQ_SQS="restaurant-queue-dlq"
ORDER_EVENTS_SNS="order-creation-events"

echo "########### Creating DLQ ###########"
aws --endpoint-url=$ENDPOINT_URL sqs create-queue --queue-name $DLQ_SQS

DLQ_SQS_ARN=arn:aws:sns:eu-central-1:000000000000:$DLQ_SQS
echo "dlqarn: $DLQ_SQS_ARN"

echo "########### Creating Source queue ###########"
aws --endpoint-url=$ENDPOINT_URL sqs create-queue --queue-name $SOURCE_SQS \
     --attributes '{
                   "RedrivePolicy": "{\"deadLetterTargetArn\":\"'"$DLQ_SQS_ARN"'\",\"maxReceiveCount\":\"2\"}",
                   "VisibilityTimeout": "5"
                   }'

#create topic, queue and subscription
aws --endpoint-url=$ENDPOINT_URL sns create-topic --name $ORDER_EVENTS_SNS --region eu-central-1 --output table | cat
aws --endpoint-url=$ENDPOINT_URL sns subscribe --topic-arn arn:aws:sns:eu-central-1:000000000000:$ORDER_EVENTS_SNS  --protocol sqs --notification-endpoint arn:aws:sqs:eu-central-1:000000000000:$SOURCE_SQS --output table | cat

echo "########### Listing queues ###########"
aws --endpoint-url=$ENDPOINT_URL sqs list-queues

echo "########### Listing Source SQS Attributes ###########"
aws --endpoint-url=$ENDPOINT_URL sqs get-queue-attributes\
                  --attribute-name All --queue-url="$ENDPOINT_URL/000000000000/$SOURCE_SQS"

aws --endpoint-url=$ENDPOINT_URL sqs get-queue-attributes\
                  --attribute-name All --queue-url="$ENDPOINT_URL/000000000000/$DLQ_SQS"


echo "### SQS SNS setup done!!"
