# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  
  # Only include tags that aren't handled by default_tags
  tags = {
    Name = "${lower(var.project_name)}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  # Only include tags that aren't handled by default_tags
  tags = {
    Name = "${lower(var.project_name)}-igw"
  }
}

/*
Public Subnets - Consolidated using for_each
Subnets
Route tables
Associations
*/
resource "aws_subnet" "public" {
  for_each               = local.public_subnets
  
  vpc_id                 = aws_vpc.vpc.id
  cidr_block             = each.value.cidr_block
  availability_zone      = each.value.availability_zone
  map_public_ip_on_launch = true
  
  # Only include tags that aren't handled by default_tags
  tags = {
    Name = each.value.name
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  # Only include tags that aren't handled by default_tags
  tags = {
    Name = "${lower(var.project_name)}-rtb-public"
  }
}

# Route Table Associations - Consolidated using for_each
resource "aws_route_table_association" "public" {
  for_each = local.public_subnets
  
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

/*
Private Subnets - Consolidated using for_each
subnets
route tables
routes
associations
*/
resource "aws_subnet" "private" {
  for_each          = local.private_subnets
  
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  
  # Only include tags that aren't handled by default_tags
  tags = {
    Name = each.value.name
  }
}

# Private Route Tables - Consolidated using for_each
resource "aws_route_table" "private" {
  for_each = local.private_subnets
  
  vpc_id = aws_vpc.vpc.id
  
  # Only include tags that aren't handled by default_tags
  tags = {
    Name = "${lower(var.project_name)}-rtb-${each.key}-${each.value.availability_zone}"
  }
}

# Routes for private route tables to NAT instance - Consolidated using for_each
resource "aws_route" "private_default" {
  for_each = local.private_subnets
  
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}

# Private subnets route table associations - Consolidated using for_each
resource "aws_route_table_association" "private" {
  for_each = local.private_subnets
  
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
