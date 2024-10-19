data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/Databse_contente"
  output_path = "${path.module}/Databse_contente/lambda_package.zip"
}


resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"

  handler = "lambda_code.lambda_code.lambda_handler"
  runtime = "python3.8"

  filename = data.archive_file.lambda.output_path

  role = aws_iam_role.lambda_exec_role.arn


  vpc_config {
    subnet_ids         = [aws_subnet._prSubnet_1.id, aws_subnet._prSubnet_2.id]
    security_group_ids = [aws_security_group._SG_RDS.id]
  }
  environment {
    variables = {
      DB_HOST     = aws_db_instance._mysql.endpoint
      DB_USER     = var.DB-admin
      DB_PASSWORD = var.DB-password
      DB_NAME     = var.DB-name
    }
  }
}






resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_rds_policy" {
  name = "lambda_rds_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:DescribeDBInstances",
          "rds:Connect",
          "rds-db:connect",
          "secretsmanager:GetSecretValue",
          "logs:*",
          "cloudwatch:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_rds_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_rds_policy.arn
}


