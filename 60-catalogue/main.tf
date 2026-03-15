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
        "sudo sh /tmp/bootstrap.sh catalogue dev"
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
}
