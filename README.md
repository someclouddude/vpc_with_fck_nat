# VPC with FCK-NAT Instance

A Terraform module that creates a VPC with public and private subnets using a cost-effective FCK-NAT instance instead of AWS NAT Gateway.

## Overview

This project creates a VPC infrastructure with both public and private subnets across three availability zones. Instead of using the expensive AWS NAT Gateway ($35+/month), it deploys a lightweight FCK-NAT instance (~$1/month with savings plan) to provide NAT capabilities for instances in the private subnets.

## Features

- Complete VPC setup with public and private subnets
- Cost-effective FCK-NAT instance for outbound internet access from private subnets
- Properly configured security groups
- SSM access for instance management without SSH key pairs
- Optional test instance in private subnet for verification

## Usage

```hcl
module "vpc" {
  source       = "../../config"
  environment  = "dev"
  project_name = "my-project"
}
```

## Examples

The `/env/scd` directory contains an example implementation.

## Requirements

| Name | Version |
|------|---------|
| terraform | n/a |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route.private_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.nat_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.test_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.default_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_instance.nat_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.test_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_iam_role.ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_instance_profile.ssm_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_ami.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.test_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_cidr | CIDR block for the VPC | `string` | `"10.1.0.0/16"` | no |
| region | AWS region to deploy resources | `string` | `"us-east-1"` | no |
| availability_zones | List of availability zones to use | `list(string)` | `["us-east-1a", "us-east-1b", "us-east-1c"]` | no |
| project_name | Name of the project | `string` | `"binky2"` | no |
| environment | Environment (e.g. dev, prod) | `string` | `"home"` | no |
| nat-instance_type | Instance type for NAT EC2 instance | `string` | `"t4g.small"` | no |
| test-instance_type | Instance type for test EC2 instance | `string` | `"t4g.micro"` | no |

## Outputs

| Name | Description |
|------|-------------|
| nat_instance_public_ip | The public IP address of the NAT instance |
| vpc_id | The ID of the VPC |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |

## Architecture

The architecture consists of:
- A VPC with CIDR block 10.1.0.0/16
- 3 public subnets in different AZs
- 3 private subnets in different AZs
- Internet Gateway for public subnet access
- FCK-NAT instance in public subnet for private subnet egress traffic
- Appropriate security groups and routing
- SSM access for management

## Cost Comparison

| Service | Monthly Cost |
|---------|-------------|
| AWS NAT Gateway | ~$35+ per month |
| FCK-NAT t4g.nano instance | ~$1 per month with Savings Plan |

## Notes

- FCK-NAT is a lightweight, open-source NAT solution (https://fck-nat.dev/)
- All instances use ARM64 architecture for cost optimization
- Security is maintained with proper security groups
- SSM is used for instance management instead of direct SSH access