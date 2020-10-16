# Create a Key to attach 
resource "aws_key_pair" "ecs-key-pair" {
  key_name   = "station-front-key-pair"
  public_key = file("${path.module}/key/station-front.pub")
}
