terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
  bucket = "reoliah-devops-project-terraform-state"
  key = "global/s3/terraform.tfstate"
  region = "af-south-1"
  dynamodb_table = "terraform-locks"
  encrypt = true
  }
}

# 1. Configure the Provider
provider "aws" {
  region = "af-south-1" # the selected AWS region
}

# 2. Create the Network (VPC)
# We need a VPC with Public Subnets (for Load Balancers) and Private Subnets (for Nodes)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "devops-project-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["af-south-1a", "af-south-1b"] # Must match provider region
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Saves money! (Only 1 NAT Gateway instead of 2)
  enable_vpn_gateway = false

  tags = {
    Environment = "dev"
    Project     = "devops-bootcamp"
  }
}



# 3. Create the Kubernetes Cluster (EKS)
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "devops-cluster"
  cluster_version = "1.34"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets # Nodes hide in private subnets for security

  cluster_endpoint_public_access = true   # Allows access from your laptop

  # This allows laptop (the creator) to have admin access to the cluster
  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"] # Small, cheap instances
      capacity_type  = "SPOT"        # Spot instances are 70% cheaper!
    }
  }

  tags = {
    Environment = "dev"
    Project     = "devops-bootcamp"
  }
}