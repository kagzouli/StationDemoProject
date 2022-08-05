{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3StationCI",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": ["arn:aws:s3:::station-tfstate/station-ecr.tfstate"]
        },
        {
            "Sid" : "ECRStationCI",
            "Effect": "Allow",
            "Action": [
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage"
            ],
            "Resource": "${POLICY_ECR_STATION}"
        }
    ]
}