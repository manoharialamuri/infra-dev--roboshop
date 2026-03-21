resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_ids
  vpc_security_group_ids = [local.mongodb_sg_id]

  tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-mongodb"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap" {
  triggers_replace = [
    aws_instance.mongodb.id,
    timestamp()
    #time stamp for debugging
  ]

  # # SSH connection configuration
  connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.mongodb.private_ip
  }

  # File provisioner to copy a script to the instance
  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Remote destination path
}

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",  
        "sudo sh /tmp/bootstrap.sh mongodb"
    ] 
  }
}

#creating redis
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_ids
  vpc_security_group_ids = [local.redis_sg_id]

  tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-redis"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap_redis" {
  triggers_replace = [
    aws_instance.redis.id,
    timestamp()
    #time stamp for debugging
  ]

  # # SSH connection configuration
  connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.redis.private_ip
  }

  # File provisioner to copy a script to the instance
  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Remote destination path
}

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",  
        "sudo sh /tmp/bootstrap.sh redis"
    ] 
  }
}

#creating mysql
resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_ids
  vpc_security_group_ids = [local.mysql_sg_id]
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-mysql"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap_mysql" {
  triggers_replace = [
    aws_instance.mysql.id,
    timestamp()
    #time stamp for debugging
  ]

  # # SSH connection configuration
  connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.mysql.private_ip
  }

  # File provisioner to copy a script to the instance
  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Remote destination path
}

  provisioner "remote-exec" {
    inline = [
        
        "chmod +x /tmp/bootstrap.sh",  
        "sudo sh /tmp/bootstrap.sh mysql ${var.enviornment}"
    ] 
  }
}

#creating rabbitmq
resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.database_subnet_ids
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  #iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = merge(
    
    {
        Name = "${var.project}-${var.enviornment}-rabbitmq"
    },
    local.common_tags
  )
}

resource "terraform_data" "bootstrap_rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id,
    timestamp()
    #time stamp for debugging
  ]

  # # SSH connection configuration
  connection {
  type = "ssh"
  user = "ec2-user"
  password = "DevOps321"
  host = aws_instance.rabbitmq.private_ip
  }

  # File provisioner to copy a script to the instance
  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Remote destination path
}

  provisioner "remote-exec" {
    inline = [
        
        "chmod +x /tmp/bootstrap.sh",  
        "sudo sh /tmp/bootstrap.sh rabbitmq ${var.enviornment}"
    ] 
  }
}

#for dir in 40.database 30.bastion 20-sg-rules 10-sg 00-vpc; do (cd $dir && terraform destroy -auto-approve); done

#for i in 00-vpc/ 10-sg/ 20-sg-rules/ 30-bastion/; 50-backend-alb/; do cd $i; terraform apply -auto-approve; cd ..;done