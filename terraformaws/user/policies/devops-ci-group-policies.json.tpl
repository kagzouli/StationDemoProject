{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": [ 
             "sts:AssumeRole",
             "sts:TagSession"
        ],
        "Resource": [
          "${ROLE_TO_ASSUME_DEVOPS_CI}"
        ] 
    }
}
