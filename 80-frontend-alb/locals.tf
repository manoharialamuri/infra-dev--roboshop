locals {
  common_tags = {
    project = var.project
    enviornment = var.enviornment
    terraform = "true"
  }
#   ami_id = data.aws_ami.example.id
  frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  frontend_alb_certificate_arn = data.aws_ssm_parameter.frontend_alb_certificate_arn.value

}