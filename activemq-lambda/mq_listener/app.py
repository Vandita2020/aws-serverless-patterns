import json


def lambda_handler(event, context):

    print(f"event={event}")
    print(f"context={context}")

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Update Invoke from MQ - Complete -",
        }),
    }
