resource "aws_iam_role" "mysql" {
  name = local.mysql_role_name #Roboshop-Dev-Mysql
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    {
        Name = local.mysql_role_name
    },
    local.common_tags
  )
}

resource "aws_iam_role_policy_attachment" "bastion" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.project}-${var.enviornment}-bastion"
  role = aws_iam_role.bastion.name
}