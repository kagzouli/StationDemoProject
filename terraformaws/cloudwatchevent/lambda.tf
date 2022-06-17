locals {
    function_name_monitoring = "lambda-monitoring"
    source_file_monitoring   = "lambda-monitoring.zip" 
    main_file_monitoring     = "monitoring.py"
}


# Package lambda monitoring
resource "null_resource" "packaging_lambda_monitoring" {
  provisioner "local-exec" {
    command = "${path.cwd}/sources/createpack_pip3.sh $SOURCE_DIR \"$MAIN_FILE\" > /dev/null"
    environment = {
      SOURCE_DIR = local.function_name_monitoring
      MAIN_FILE  = local.main_file_monitoring
    }
  }  
  
  triggers = {
    run_everytime = timestamp()
  }
  
}


data "archive_file" "monitoring_zip" {
  type = "zip"
  source_dir = "${path.cwd}/sources/${local.function_name_monitoring}/.package"
  output_path = "${path.cwd}/sources/${local.function_name_monitoring}/${local.source_file_monitoring}"
  
  depends_on = [
    null_resource.packaging_lambda_monitoring
  ]
}

resource "null_resource" "pushing_lambda_monitoring_code" {
  provisioner "local-exec" {
    command = "aws s3 cp ./sources/$SOURCE_DIR/$SOURCE_FILE s3://$BUCKET_NAME/$DESTINATION_DIR/ > /dev/null"
    environment = {
      SOURCE_DIR      = "${local.function_name_monitoring}"
      DESTINATION_DIR = "${local.function_name_monitoring}"
      SOURCE_FILE     = local.source_file_monitoring
      BUCKET_NAME     = aws_s3_bucket.lambda_code_bucket.id
    }
  }

  triggers = {
    run_on_python_change = filesha1("sources/${local.function_name_monitoring}/${local.main_file_monitoring}")
  }
  
  depends_on = [
    data.archive_file.monitoring_zip
  ]
}


resource "aws_lambda_function" "monitoring" {
  function_name = "station-${local.function_name_monitoring}"
  description   = "Lambda function to monitor station"
  memory_size   = var.lambda_memory_size_monitoring
  timeout       = var.lambda_timeout_monitoring
 
  s3_bucket     =  aws_s3_bucket.lambda_code_bucket.id
  s3_key        = "${local.function_name_monitoring}/${local.source_file_monitoring}"  

  source_code_hash = data.archive_file.monitoring_zip.output_base64sha256
  role             = aws_iam_role.lambda_monitoring.arn

  handler = "monitoring.lambda_handler"
  runtime = var.lambda_runtime_monitoring
 
  environment {
    variables = {
      AWS_ACCOUNT_ID       = data.aws_caller_identity.current.account_id
      ENV_NAME             = "dev" 
      REGION               = var.region
      STATION_FRONT_LB_ARN = data.aws_alb.station_front_alb.arn
      STATION_FRONT_TG_ARN = data.aws_alb_target_group.station_front_target_group.arn
      STATION_BACK_LB_ARN  = data.aws_alb.station_back_alb.arn
      STATION_BACK_TG_ARN  = data.aws_alb_target_group.station_back_target_group.arn
    }
  }
    

 tags = {
      Name = "station-${local.function_name_monitoring}"
      Application= var.application
  }
 
  #archive_upload_depends_on can be passed by the calling module which allows to be sure we wait for code upload before lambda deployment
  depends_on = [
    aws_iam_role.lambda_monitoring,
    null_resource.pushing_lambda_monitoring_code
  ] 
}



