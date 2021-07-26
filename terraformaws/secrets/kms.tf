data "aws_iam_policy_document" "station_kms_policy" {
  statement {
    effect = "Allow"
    principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }

}

resource "aws_kms_key" "station_kms_key" {
  policy = data.aws_iam_policy_document.station_kms_policy.json
  tags = {
    Name = "station-kms-key",
    Application= var.application
  }
}


resource "aws_kms_alias" "station_key_alias" {
  name          = "alias/station-kms-key"
  target_key_id = aws_kms_key.station_kms_key.key_id
}

