#########################################
# ALB Security Group
#########################################

resource "aws_security_group" "alb" {

  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

#########################################
# Kubernetes Master SG
#########################################

resource "aws_security_group" "master" {

  name   = "${var.project_name}-${var.environment}-master-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  ingress {

    from_port = 10250
    to_port   = 10250
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  ingress {

    from_port = 30000
    to_port   = 32767
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-master-sg"
  }

}

#########################################
# Worker Node SG
#########################################

resource "aws_security_group" "worker" {

  name   = "${var.project_name}-${var.environment}-worker-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  ingress {

    from_port = 10250
    to_port   = 10250
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  ingress {

    from_port = 30000
    to_port   = 32767
    protocol  = "tcp"

    cidr_blocks = [
      var.vpc_cidr
    ]
  }

  ingress {

    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  ingress {

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-worker-sg"
  }

}

#########################################
# PostgreSQL SG
#########################################

resource "aws_security_group" "postgres" {

  name   = "${var.project_name}-${var.environment}-postgres-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [
      aws_security_group.worker.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-postgres-sg"
  }

}

#########################################
# Monitoring SG
#########################################

resource "aws_security_group" "monitoring" {

  name   = "${var.project_name}-${var.environment}-monitoring-sg"
  vpc_id = var.vpc_id

  ingress {

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-monitoring-sg"
  }

}
