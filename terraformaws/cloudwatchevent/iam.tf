# Role and policy for lambda to get and put data on cloudwatch and inspect target group or ALB
resource "aws_iam_role" "lambda_monitoring" {
  name = "station-lambda-monitoring"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

 tags = {
      Name = "station-lambda-monitoring"
      Application= var.application
  }



}



resource "aws_iam_policy" "lambda_monitoring_policy" {
  name = "station-lambda-monitoring-policy"

  policy = <<POLICY
{

	"Version": "2012-10-17",
	"Statement": [
    {
		  "Effect": "Allow",
		  "Action": [
		    "cloudwatch:PutMetricData",
       		    "cloudwatch:GetMetricData"
		  ],
		  "Resource": "*"
	  },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeTargetGroups"

      ],
      "Resource": "*"
     }
    ]
}
POLICY

}



# Attach policy lambda monitoring to role
resource "aws_iam_role_policy_attachment" "lambda_monitoring_policy_attachment" {
  role      = aws_iam_role.lambda_monitoring.name
  policy_arn = aws_iam_policy.lambda_monitoring_policy.arn

}

# AWS lambda basic role. 
resource "aws_iam_role_policy_attachment" "AmazonLambdaBasicExecutionRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_monitoring.name
}



