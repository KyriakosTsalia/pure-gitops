data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.available.names
}

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "4.0.1"

#   name = "main"
#   cidr = "10.0.0.0/16"

#   azs             = data.aws_availability_zones.available.names
#   public_subnets  = [for index, _ in local.azs : "10.0.${index}.0/24"]
#   private_subnets = [for index, _ in local.azs : "10.0.${100 + index}.0/24"]

#   enable_nat_gateway   = true
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   public_subnet_tags = {
#     Name = "main-public"
#   }

#   private_subnet_tags = {
#     Name = "main-private"
#   }

#   vpc_tags = {
#     Name = "main"
#   }
# }