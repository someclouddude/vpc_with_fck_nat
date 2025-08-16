# IAM Role and Instance Profile for SSM
resource "aws_iam_role" "ssm_role" {
  name = "ssm_instance_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

# NAT Instance instead of NATGW ... like $1 a month with savings plan and t4g.nano instead of $35
# Single instance with all private subnets routing to AZa (defined in routes) to save $
data "aws_ami" "nat" {
  most_recent = true

# fck-nat https://fck-nat.dev/stable/
  owners = ["568608671756"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}


resource "aws_instance" "nat_instance" {
  ami                    = data.aws_ami.nat.id
  instance_type          = var.nat-instance_type
  subnet_id              = aws_subnet.public["public1"].id
  key_name               = "scd_mcp"
  source_dest_check      = false
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.nat_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  
  tags = {
    Name = "Shared NAT Instance"
  }
}

# Test Instance
data "aws_ami" "test_instance" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_instance" "test_instance" {
  ami                    = data.aws_ami.test_instance.id
  instance_type          = var.test-instance_type
  subnet_id              = aws_subnet.private["private1"].id
  key_name               = "scd_mcp"
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  
  tags = {
    Name = "Test Instance"
  }
}
