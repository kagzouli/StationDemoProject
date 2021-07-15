# Create a Key to attach 
resource "aws_key_pair" "kubernetesmaster-key-pair" {
  key_name   = "kubernetesmaster-key-pair"
  public_key = file("${path.module}/key/ec2.pub")
}
