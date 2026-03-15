locals {
  common_tags = {
    project = var.project
    enviornment = var.enviornment
    terraform = "true"
  }
#   ami_id = data.aws_ami.example.id
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)

}