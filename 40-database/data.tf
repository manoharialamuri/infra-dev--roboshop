data "aws_ami" "example" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
     name   = "name"
     values = ["Redhat-9-DevOps-Practice"]
  }
   filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project}/${var.enviornment}/database_subnet_ids"
}

data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.enviornment}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.enviornment}/redis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.enviornment}/mysql_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.enviornment}/rabbitmq_sg_id"
}