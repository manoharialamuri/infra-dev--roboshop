variable "project" {
  default = "roboshop"
}

variable "enviornment" {
  default = "dev"
}

variable "bastion_tags" {
  type = map
  default = {}
}