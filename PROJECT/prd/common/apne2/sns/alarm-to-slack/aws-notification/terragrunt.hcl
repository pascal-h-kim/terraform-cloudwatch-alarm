terraform {
  source = "../../../../../../../SERVICE/sns/topic"
}

include {
  path = "${find_in_parent_folders()}"
}

dependencies {
  paths = []
}

inputs = {
  name = "slack-alarm-aws-notification"
  policy = <<EOT
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
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
      "Resource": "arn:aws:sns:ap-northeast-2:468720534852:slack-alarm-aws-notification",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "468720534852"
        }
      }
    },
    {
      "Sid": "AllowPublishEvents",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": "*"
    }
  ]
}
EOT
}
