#https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.5.2
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs  = var.vpc_azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets

  # azs             = ["us-east-1a"]
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  # public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]


  create_igw             = true
  enable_nat_gateway     = true
  create_egress_only_igw = true
  single_nat_gateway     = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}