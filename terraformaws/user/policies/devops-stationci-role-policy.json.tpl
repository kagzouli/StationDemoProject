{
    "Version": "2012-10-17",
    "Statement": [
        {
	    "Sid": "GetAuthStationCI",
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        },
        {
            "Sid": "S3StationCI",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": ["arn:aws:s3:::station-tfstate/station-ecr.tfstate"]
        },
        {
            "Sid" : "ECRManageStationRegistryCI",
            "Effect": "Allow",
            "Action": [
                "ecr:CreateRepository",
                "ecr:DescribeRepositories",
                "ecr:ListTagsForResource",
                "ecr:SetRepositoryPolicy",
                "ecr:GetRepositoryPolicy",
		"ecr:DeleteRepository",
		"ecr:DeleteRepositoryPolicy"
            ],
            "Resource": "${POLICY_ECR_STATION}"
        },

        {
            "Sid" : "ECRPushStationCI",
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
