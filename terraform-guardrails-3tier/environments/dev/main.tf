data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

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

#=======================Guardrails Module========================
module "guardrails" {

  source = "../../modules/guardrails"

  aws_region           = var.aws_region
  project_name         = var.project_name
  environment          = var.environment
  expected_environment = "dev"
  owner                = var.owner
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

  vpc_id   = module.vpc.vpc_id
  vpc_cidr = "10.0.0.0/16"
}
#===================ec2 Module========================
module "ec2" {

  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  ami           = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type = "t3.medium"
  key_name      = "LLB-new"

  public_subnet_id = module.vpc.public_subnet_ids[0]

  private_subnet_ids = module.vpc.private_subnet_ids

  master_sg     = module.security_groups.master_sg
  worker_sg     = module.security_groups.worker_sg
  monitoring_sg = module.security_groups.monitoring_sg

}

#===================ALB Module========================
module "alb" {

  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg            = module.security_groups.alb_sg

  target_instance_ids = [
    module.ec2.worker1_id,
    module.ec2.worker2_id
  ]
}

#===================WAF Module========================
module "waf" {

  source = "../../modules/waf"

  project_name = var.project_name
  environment  = var.environment

  alb_arn = module.alb.alb_arn
}

#===================Monitoring Module========================
module "monitoring" {

  source = "../../modules/monitoring"

  project_name = var.project_name
  environment  = var.environment

  instance_ids = [
    module.ec2.master_id,
    module.ec2.worker1_id,
    module.ec2.worker2_id
  ]

  instance_names = [
    "master",
    "worker1",
    "worker2"
  ]
}
