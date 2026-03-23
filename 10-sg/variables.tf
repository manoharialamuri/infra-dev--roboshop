variable "project" {
    default = "roboshop"
}

variable "enviornment" {
    default = "dev"
}

variable "sg_names" {
  type = list
  default = [
    #databases
    "mongodb", "redis", "mysql", "rabbitmq",
    #backend
    "catalogue", "cart", "user", "shipping", "payment",
    #backend-alb
    "backend_alb",
    #frontend
    "frontend",
    #frontend-alb
    "frontend_alb",
    #bastion
    "bastion",
    #openvpn
    "openvpn"
  ]
}

