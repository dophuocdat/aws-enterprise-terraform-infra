terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"

}

#goi module VPC cho moi truong staging voi dai IP Class B chuan Enterprise

module "vpc_staging" {
  source             = "../../modules/vpc"
  env_name           = "staging"
  aws_region         = "ap-southeast-1"
  vpc_cidr           = "172.24.0.0/16"
  enable_nat_gateway = false
}

#in ket qua 
output "staging_network_summary" {
  value = {
    vpc_id        = module.vpc_staging.vpc_id
    public_cidrs  = module.vpc_staging.public_subnet_cidrs
    private_cidrs = module.vpc_staging.private_subnet_cidrs
    s3_prefix_id  = module.vpc_staging.s3_endpoint_prefix_list
  }

}
