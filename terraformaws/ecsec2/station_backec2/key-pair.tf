# Create a Key to attach 
resource "aws_key_pair" "ecs-key-pair" {
  key_name   = "station-back-key-pair"
  public_key = file("${path.module}/key/station-back.pub")
}
