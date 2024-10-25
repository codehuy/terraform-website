
import json
import boto3
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('resume-views')

def lambda_handler(event, context):
    response = table.get_item(Key={'id': '1'})
    views = response['Item']['views']
    views += 1
    table.put_item(Item={'id': '1', 'views': views})
    return views