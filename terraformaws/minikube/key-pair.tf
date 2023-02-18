# Create a Key to attach 
resource "aws_key_pair" "minikube-key-pair" {
  key_name   = "minikube-key-pair"
  public_key = file("${path.module}/key/ec2.pub")
}
