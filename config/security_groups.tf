# Security Groups
resource "aws_security_group" "nat_sg" {
  # Security groups have a name attribute
  name        = "fck-nat"
  description = "NAT instance security group"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "vpc cidr"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "test_sg" {
  # Security groups have a name attribute
  name        = "launch-wizard-1"
  description = "SSH access for test instance"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "default_sg" {
  # Security groups have a name attribute
  name        = "default-like"
  description = "Default-like VPC security group"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all traffic from the same security group"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}
