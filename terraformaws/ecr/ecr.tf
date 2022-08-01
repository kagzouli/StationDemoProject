locals {
 # role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/devops-ci"
   role_arn = "*"
}


################### Registry database ######################################################################
resource "aws_ecr_repository" "station_database_registry" {
    name  = "station/station-db"
    image_tag_mutability = var.image_tag_mutability
    force_delete  = var.force_delete_ecr
    image_scanning_configuration {
      scan_on_push = true
    }
  
    tags = {
     Name = "station-db-ecr"
     Application= var.application
    }

}

resource "aws_ecr_repository_policy" "station_database_registry_policy" {
  repository = aws_ecr_repository.station_database_registry.name

  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "private access for db repository",
        "Effect": "Allow",
        "Principal": 
          {
            "AWS": "${local.role_arn}" 
          },
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  
}
  EOF
    
}

##################### Registry back ##############################################################
resource "aws_ecr_repository" "station_back_registry" {
    name  = "station/station-back"
    image_tag_mutability = var.image_tag_mutability
    force_delete  = var.force_delete_ecr
    image_scanning_configuration {
      scan_on_push = true
    }
  
    tags = {
     Name = "station-back-ecr"
     Application= var.application
    }

}

resource "aws_ecr_repository_policy" "station_back_registry_policy" {
  repository = aws_ecr_repository.station_back_registry.name

  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "private access for back repository",
        "Effect": "Allow",
        "Principal":
          {
            "AWS": "${local.role_arn}"
          },
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  
}
  EOF
    
}


##################### Registry front ##############################################################
resource "aws_ecr_repository" "station_front_registry" {
    name  = "station/station-front-nginx"
    image_tag_mutability = var.image_tag_mutability
    force_delete  = var.force_delete_ecr
    image_scanning_configuration {
      scan_on_push = true
    }
  
    tags = {
     Name = "station-front-nginx-ecr"
     Application= var.application
    }

}

resource "aws_ecr_repository_policy" "station_front_registry_policy" {
  repository = aws_ecr_repository.station_front_registry.name

  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "private access for front repository",
        "Effect": "Allow",
        "Principal":
        {
          "AWS": "${local.role_arn}"
        },
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  
}
  EOF
    
}


