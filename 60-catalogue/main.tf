resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.private_subnet_ids
  vpc_security_group_ids = [local.catalogue_sg_id]

  tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-catalogue"
    },
    local.common_tags
  )
}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id,
    #timestamp()
    #time stamp for debugging
  ]

  # # SSH connection configuration
  connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.catalogue.private_ip
  }

  # File provisioner to copy a script to the instance
  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Remote destination path
}

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",  
        "sudo sh /tmp/bootstrap.sh catalogue ${var.enviornment} ${var.app_version}"
    ] 
  }

}

resource "aws_ec2_instance_state" "catalogue" {
    instance_id = aws_instance.catalogue.id
    state = "stopped"
    depends_on = [ terraform_data.catalogue ]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.enviornment}-catalogue"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]

tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-catalogue"
    },
    local.common_tags
  )
}

#creating target group
resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.enviornment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60
  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3
  }
}

#creating launch template
resource "aws_launch_template" "catalogue" {
  name = "${var.project}-${var.enviornment}-catalogue"

  image_id = aws_ami_from_instance.catalogue.id

    # once autoscaling sees less traffic, it will terminate the instance
  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  vpc_security_group_ids = [local.catalogue_sg_id]

    # each time we apply terraform this version will be updated as default
  update_default_version = true

# tags for instances created by launch template through autoscaling
  tag_specifications {
    resource_type = "instance"

    tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-catalogue"
    },
    local.common_tags
  )
  }
# tags for volumes created by instances
  tag_specifications {
    resource_type = "volume"

    tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-catalogue"
    },
    local.common_tags
  )
  }
   # tags for launch template
    tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-catalogue"
    },
    local.common_tags
  )
  }

#creating autoscailing group
resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project}-${var.enviornment}-catalogue"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [local.private_subnet_ids]
  target_group_arns = [aws_lb_target_group.catalogue.arn]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  dynamic "tag" {
    for_each = merge(
    {
        Name = "${var.project}-${var.enviornment}-catalogue"
    },
    local.common_tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
    }
    

   # with in 15min autoscaling should be successful
  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${var.project}-${var.enviornment}-catalogue"
  estimated_instance_warmup = 120
  policy_type            = "TargetTrackingScaling"

target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

#creating listener rule
# This depends on target group
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.enviornment}.${var.domain_name}"]
    }
  }
}

resource "terraform_data" "catalogue_delete" {
  triggers_replace = [
    aws_instance.catalogue.id,
    #timestamp()
    #time stamp for debugging
  ]

    depends_on = [ aws_autoscaling_policy.catalogue ]
   #it executes in bastion
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id} "
  }

}
