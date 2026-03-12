module "vpc" {
  source = "git::https://github.com/manoharialamuri/terraform-aws-vpc.git?ref=main"
  project = var.project
  enviornment = var.enviornment
  is_peering_required = true
}