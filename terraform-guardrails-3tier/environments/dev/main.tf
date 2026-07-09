module "vpc" {

  source = "../../modules/vpc"

  project_name = var.project_name

  environment = var.environment

  vpc_cidr = "10.0.0.0/16"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}
#=======================IAM Module========================
# module "iam" {

#   source = "../../modules/iam"

#   project_name = var.project_name

#   environment = var.environment

# }
#===================security-groups Module========================
module "security_groups" {

  source = "../../modules/security-groups"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id
}
#===================ec2 Module========================
module "ec2" {

  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  ami           = "ami-xxxxxxxx"
  instance_type = "t3.medium"
  key_name      = "your-keypair"

  public_subnet_id = module.vpc.public_subnet_ids[0]

  private_subnet_ids = module.vpc.private_subnet_ids

  master_sg     = module.security_groups.master_sg
  worker_sg     = module.security_groups.worker_sg
  monitoring_sg = module.security_groups.monitoring_sg

}