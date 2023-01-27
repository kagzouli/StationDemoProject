# Create a Key to attach 
resource "aws_key_pair" "kubernetesvaultonprem-key-pair" {
  key_name   = "kubernetesvaultonprem-key-pair"
  public_key = file("${path.module}/key/ec2.pub")
}
