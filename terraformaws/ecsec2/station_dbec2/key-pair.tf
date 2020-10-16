# Create a Key to attach 
resource "aws_key_pair" "ecs-key-pair" {
  key_name   = "station-db-key-pair"
  public_key = file("${path.module}/key/station-db.pub")
}
