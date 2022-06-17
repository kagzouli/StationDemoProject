data "aws_caller_identity" "current" {}


data "aws_alb" "station_front_alb"{
    name = "station-front-alb"
}


data "aws_alb_target_group" "station_front_target_group" {
  name = "station-front-target-group"
}


data "aws_alb" "station_back_alb"{
    name = "station-back-alb"
}


data "aws_alb_target_group" "station_back_target_group" {
  name = "station-back-target-group"
}
