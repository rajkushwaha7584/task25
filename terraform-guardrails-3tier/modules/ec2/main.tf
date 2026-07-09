#############################################
# Bastion Host
#############################################

resource "aws_instance" "bastion" {

  ami                         = var.ami
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    var.master_sg
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-bastion"
  }
}

#############################################
# Kubernetes Master
#############################################

resource "aws_instance" "master" {

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[0]

  key_name = var.key_name

  vpc_security_group_ids = [
    var.master_sg
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-master"
  }
}

#############################################
# Worker Node 1
#############################################

resource "aws_instance" "worker1" {

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[0]

  key_name = var.key_name

  user_data                   = var.worker_user_data
  user_data_replace_on_change = true

  vpc_security_group_ids = [
    var.worker_sg
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-worker1"
  }
}

#############################################
# Worker Node 2
#############################################

resource "aws_instance" "worker2" {

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[1]

  key_name = var.key_name

  user_data                   = var.worker_user_data
  user_data_replace_on_change = true

  vpc_security_group_ids = [
    var.worker_sg
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-worker2"
  }
}

#############################################
# Monitoring Server
#############################################

resource "aws_instance" "monitoring" {

  ami                         = var.ami
  instance_type               = "t3.medium"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    var.monitoring_sg
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-monitoring"
  }
}
