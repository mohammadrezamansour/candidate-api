import json
from aws_services import create_candidate, get_candidate


def lambda_handler(event, context):
    route = event["requestContext"]["routeKey"]

    if route == "POST /candidate":
        return create_candidate(event)

    if route == "GET /candidate/{id}":
        return get_candidate(event)

    return {
        "statusCode": 404,
        "body": json.dumps({"message": "Route not found"})
    }