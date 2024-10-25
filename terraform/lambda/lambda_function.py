import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('resume-views')

# Helper function to convert Decimal to int or float because AWS DynamoDB uses the Decimal type to represent numbers
def decimal_default(obj):
    if isinstance(obj, Decimal):
        return int(obj) if obj % 1 == 0 else float(obj)
    raise TypeError

def lambda_handler(event, context):
    try:
        response = table.get_item(Key={'id': '1'})
        
        # Check if the item exists, and set views to 1 if not
        if 'Item' not in response:
            views = 1
        else:
            views = response['Item']['views']
            views += 1  

        table.put_item(Item={'id': '1', 'views': views})

        # Return the updated view count, using a helper function to serialize Decimal
        return {
            'statusCode': 200,
            'body': json.dumps({'views': views}, default=decimal_default)
        }
    
    except Exception as e:
        print(f"Error updating view count: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
