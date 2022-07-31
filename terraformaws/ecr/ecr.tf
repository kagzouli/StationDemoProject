# Registry database
resource "aws_ecr_repository" "station_database_registry" {
    name  = "station-ecr-registry/station-db"
    image_tag_mutability = var.image_tag_mutability
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
        "Sid": "private access for ${var.images_name[count.index]} repository",
        "Effect": "Allow",
        "Principal": 
          {"AWS": "${local.arn}" },
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
