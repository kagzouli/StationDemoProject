import json

def scaleUpHandler(event, context):
    return {
        'statusCode': 200,
        'body': 'Scale up'
    }

def scaleDownHandler(event, context):
    return {
        'statusCode': 200,
        'body': 'Scale Down'
    }