# /* resource "aws_ssm_parameter" "mongodb_sg_id" {
#   name  = "/${var.project}/${var.enviornment}/mongodb_sg_id"
#   type  = "String"
#   value = module.sg.sg_id
# } */


resource "aws_ssm_parameter" "sg_ids" {
  count = length(var.sg_names)
  name  = "/${var.project}/${var.enviornment}/${var.sg_names[count.index]}_sg_id"
  type  = "String"
  value = module.sg[count.index].sg_id
 }