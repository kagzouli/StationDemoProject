resource "aws_sns_topic" "station_cloudwatch_events_sns_alerting" {

    name = "station-cloudwatch-events-topic"

    display_name = "station-cloudwatch-events-topic"

    policy = <<POLICY
    {
        "Version": "2008-10-17",
        "Id": "autotag_policy_ID",

        "Statement": [

        {

            "Sid": "station_cloudwatch_events_sns_statement_ID",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },

            "Action": [

                "SNS:GetTopicAttributes",
                "SNS:SetTopicAttributes",
                "SNS:AddPermission",
                "SNS:RemovePermission",
                "SNS:DeleteTopic",
                "SNS:Subscribe",
                "SNS:ListSubscriptionsByTopic",
                "SNS:Publish",
                "SNS:Receive"
            ],

            "Resource": "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:station-cloudwatch-events-topic"

        }
        ]
}
POLICY
tags = {
      Name = "startion-cloudwatch-events-topic"
      Application= var.application
  }


}


resource "null_resource" "station_cloudwatch_subscribe" {

    depends_on = [ aws_sns_topic.station_cloudwatch_events_sns_alerting ]

    triggers = {
        sns_topic_arn = "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:station-cloudwatch-events-topic"
    }

    count = length(var.mail_cloudwatch_alert)

    provisioner "local-exec" {
        command = "aws sns subscribe --topic-arn ${aws_sns_topic.station_cloudwatch_events_sns_alerting.arn} --protocol email --notification-endpoint ${element(var.mail_cloudwatch_alert, count.index)}"
    }

}
