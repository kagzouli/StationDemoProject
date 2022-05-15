import json

def get_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Call the addiinfo get method'
    }

def delete_handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Call the addiinfo delete method'
    }

