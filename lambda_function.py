def lambda_handler(event, context):

    return {
        "statusCode": 200,
        "body": "HELLO WORLD FROM THE LAMBDA HANDLER"
    }

if __name__ == "__main__":
    lambda_handler(None, None)