
# DynamoDB Table for View Count
resource "aws_dynamodb_table" "resume_views" {
  name           = "resume-views"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_role" {
  name = "lambda_resume_view_counter_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# IAM Policy for Lambda to access DynamoDB and CloudWatch
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name = "lambda_dynamodb_policy"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ],
        "Resource": "arn:aws:dynamodb:${var.aws_region}:*:table/${aws_dynamodb_table.resume_views.name}"
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# Lambda Function that updates the DynamoDB table
resource "aws_lambda_function" "view_counter_lambda" {
  function_name    = "resume-view-counter"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.8"
  handler          = "lambda_function.lambda_handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.resume_views.name
    }
  }
}

# Archive Lambda Python Code (local packaging)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_function.py"  # Ensure this path matches your local code
  output_path = "${path.module}/lambda/lambda_Function.zip"
}

# Lambda Function URL to invoke the Lambda function
resource "aws_lambda_function_url" "view_counter_url" {
  function_name      = aws_lambda_function.view_counter_lambda.function_name
  authorization_type = "NONE"  # No auth, accessible to the public

  cors {
    allow_origins  = ["*"]  # You can restrict this for security
    allow_methods  = ["GET"]
    allow_headers  = ["*"]
  }
}

# CloudWatch Log Group for Lambda Function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.view_counter_lambda.function_name}"
  retention_in_days = 14
}

# Output the Lambda URL to use on your website
output "lambda_function_url" {
  value = aws_lambda_function_url.view_counter_url.function_url
}
