Elixir services communicating through events 

## Use case
![Alt text](event-driv.drawio.png?raw=true)

The application handles a very basic case of delivery.
Users can create orders which will be validated against a restaurant. Depending on the restaurants
reply, the order will be confirmed or rejected.

## Setup
The services are built with the mix generators so there is a lot of unused boilerplate code

Localstack helping with the aws infrastructure: sqs sns

The state management is done with machinery. It's a nice library with good features but is very 
limiting as it doesn't allow multiple operations within its features in a single transaction. 
For this showcase is good enough.

# Getting started
start application:
- docker-compose up

run tests
- docker-compose up
- mix tests


