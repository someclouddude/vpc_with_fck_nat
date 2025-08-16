# Output the NAT instance's public IP address
output "nat_instance_public_ip" {
  description = "The public IP address of the NAT instance"
  value       = aws_instance.nat_instance.public_ip
}

# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

# Output public subnet IDs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = { for k, v in aws_subnet.public : k => v.id }
}

# Output private subnet IDs
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = { for k, v in aws_subnet.private : k => v.id }
}
