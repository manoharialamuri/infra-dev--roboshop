locals {
  common_tags = {
    project = var.project
    enviornment = var.enviornment
    terraform = "true"
  }
  ami_id = data.aws_ami.example.id
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
}