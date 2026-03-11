module "sg" {
  source = "../../terraform-aws-sg"
  project = var.project
  enviornment = var.enviornment
  sg_name = "mongodb"
  vpc_id = local.vpc_id
}