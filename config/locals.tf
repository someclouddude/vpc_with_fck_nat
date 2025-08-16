# Local variables shared across multiple files
locals {
  # Subnet configurations
  public_subnets = {
    "public1" = {
      cidr_block        = "10.1.0.0/25"
      availability_zone = var.availability_zones[0]
      name              = "${lower(var.project_name)}-subnet-public1-${var.availability_zones[0]}"
    },
    "public2" = {
      cidr_block        = "10.1.16.0/25"
      availability_zone = var.availability_zones[1]
      name              = "${lower(var.project_name)}-subnet-public2-${var.availability_zones[1]}"
    },
    "public3" = {
      cidr_block        = "10.1.32.0/25"
      availability_zone = var.availability_zones[2]
      name              = "${lower(var.project_name)}-subnet-public3-${var.availability_zones[2]}"
    }
  }
  
  private_subnets = {
    "private1" = {
      cidr_block        = "10.1.128.0/20"
      availability_zone = var.availability_zones[0]
      name              = "${lower(var.project_name)}-subnet-private1-${var.availability_zones[0]}"
    },
    "private2" = {
      cidr_block        = "10.1.144.0/20"
      availability_zone = var.availability_zones[1]
      name              = "${lower(var.project_name)}-subnet-private2-${var.availability_zones[1]}"
    },
    "private3" = {
      cidr_block        = "10.1.160.0/20"
      availability_zone = var.availability_zones[2]
      name              = "${lower(var.project_name)}-subnet-private3-${var.availability_zones[2]}"
    }
  }
}
