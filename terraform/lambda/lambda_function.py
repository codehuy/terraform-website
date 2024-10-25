
import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('resume-views')

def lambda_handler(event, context):
    try:
        # Get the current view count
        response = table.get_item(Key={'id': '1'})
        
        # Check if the item exists, and set views to 1 if not
        if 'Item' not in response:
            views = 1
        else:
            views = response['Item']['views']
            views += 1  # Increment the view count

        # Update the DynamoDB table with the new view count
        table.put_item(Item={'id': '1', 'views': views})
        
        # Return the updated view count
        return {
            'statusCode': 200,
            'body': json.dumps({'views': views})
        }
    
    except Exception as e:
        print(f"Error updating view count: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
