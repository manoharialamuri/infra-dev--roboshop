module "vpc" {
  source = "../../terraform-aws-vpc"
  project = var.project
  enviornment = var.enviornment
  is_peering_required = true
}