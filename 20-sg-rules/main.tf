#bastion 
resource "aws_security_group_rule" "bastion_internet" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks       = [local.my_ip]
  #sg will be the dest sg id that is bastion
  security_group_id = local.bastion_sg_id
}

#mongodb
resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  #where traffic is coming from catalogue is the source
  source_security_group_id = local.catalogue_sg_id
  security_group_id = local.mongodb_sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  #where traffic is coming from user is the source
  source_security_group_id = local.user_sg_id
  #where we are using this ag rule
  security_group_id = local.mongodb_sg_id
}

#redis
resource "aws_security_group_rule" "redis_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  #where traffic is coming from cart is the source
  source_security_group_id = local.cart_sg_id
  security_group_id = local.redis_sg_id
}

resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  #where traffic is coming from user is the source
  source_security_group_id = local.user_sg_id
  security_group_id = local.redis_sg_id
}

#mysql
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.mysql_sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.shipping_sg_id
  security_group_id = local.mysql_sg_id
}

#rabbitmq
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.rabbitmq_sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  #where traffic is coming from payment is the source
  source_security_group_id = local.payment_sg_id
  security_group_id = local.rabbitmq_sg_id
}

#catalogue
#catalogue accepting connections from bastion
resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  #where we are using this ag rule
  security_group_id = local.catalogue_sg_id
}

#catalogue accepting connections from backend-alb
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  #where traffic is coming from backend_alb is the source
  source_security_group_id = local.backend_alb_sg_id
  #where we are using this ag rule
  security_group_id = local.catalogue_sg_id
}

#user
resource "aws_security_group_rule" "user_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  #where we are using this ag rule
  security_group_id = local.user_sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.backend_alb_sg_id
  #where we are using this ag rule
  security_group_id = local.user_sg_id
}

#cart
resource "aws_security_group_rule" "cart_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  #where we are using this ag rule
  security_group_id = local.cart_sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.backend_alb_sg_id
  #where we are using this ag rule
  security_group_id = local.cart_sg_id
}

#shipping
resource "aws_security_group_rule" "shipping_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  #where we are using this ag rule
  security_group_id = local.shipping_sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.backend_alb_sg_id
  #where we are using this ag rule
  security_group_id = local.shipping_sg_id
}

#payment
resource "aws_security_group_rule" "payment_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.bastion_sg_id
  #where we are using this ag rule
  security_group_id = local.payment_sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  #where traffic is coming from bastion is the source
  source_security_group_id = local.backend_alb_sg_id
  #where we are using this ag rule
  security_group_id = local.payment_sg_id
}

#backend_alb
#backend-alb accepting connections from bastion
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  #where traffic is coming from backend_alb is the source
  source_security_group_id = local.bastion_sg_id
  #where we are using this ag rule
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_catalogue" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = local.catalogue_sg_id
  #where we are using this ag rule
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_user" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = local.user_sg_id
  #where we are using this ag rule
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = local.cart_sg_id
  #where we are using this ag rule
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = local.shipping_sg_id
  #where we are using this ag rule
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = local.payment_sg_id
  #where we are using this ag rule
  security_group_id = local.backend_alb_sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = local.frontend_sg_id
  #where we are using this ag rule
  security_group_id = local.backend_alb_sg_id
}

#frontend
resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #where traffic is coming from backend_alb is the source
  source_security_group_id = local.bastion_sg_id
  #where we are using this ag rule
  security_group_id = local.frontend_sg_id
}

resource "aws_security_group_rule" "frontend_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = local.frontend_alb_sg_id
  #where we are using this ag rule
  security_group_id = local.frontend_sg_id
}

#frontend_alb
resource "aws_security_group_rule" "frontend_alb_internet" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  #cidr_blocks       = ["0.0.0.0/0"]
  cidr_blocks       = [local.my_ip]
  #sg will be the dest sg id that is bastion
  security_group_id = local.frontend_alb_sg_id
}