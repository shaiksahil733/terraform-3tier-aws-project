resource "aws_security_group" "ntier_alb" {
  name        = var.ntier_alb.Name
  description = var.ntier_alb.description #"Allow HTTP and HTTPS from internet"
  vpc_id      = aws_vpc.ntier.id
  tags = {
    Name = var.ntier_alb.Name
  }
}
resource "aws_vpc_security_group_ingress_rule" "alb_ingress" {
  count             = length(var.ntier_alb.ingress)
  description       = var.ntier_alb.ingress[count.index].description
  security_group_id = aws_security_group.ntier_alb.id
  from_port         = var.ntier_alb.ingress[count.index].from_port
  to_port           = var.ntier_alb.ingress[count.index].to_port
  ip_protocol       = var.ntier_alb.ingress[count.index].ip_protocol
  cidr_ipv4         = var.ntier_alb.ingress[count.index].cidr_ipv4
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.ntier_alb.id
  from_port         = var.ntier_alb.egress.from_port
  to_port           = var.ntier_alb.egress.to_port
  ip_protocol       = var.ntier_alb.egress.ip_protocol
  cidr_ipv4         = var.ntier_alb.egress.cidr_ipv4
}

resource "aws_security_group" "ntier_bastion" {
  vpc_id      = aws_vpc.ntier.id
  name        = var.ntier_bastion.Name
  description = var.ntier_bastion.description #"Allow SSH only from my laptop"
  tags = {
    Name = var.ntier_bastion.Name
  }

}

resource "aws_vpc_security_group_ingress_rule" "bastion_ingress" {
  count             = length(var.ntier_bastion.ingress)
  description       = var.ntier_bastion.ingress[count.index].description
  security_group_id = aws_security_group.ntier_bastion.id
  from_port         = var.ntier_bastion.ingress[count.index].from_port
  to_port           = var.ntier_bastion.ingress[count.index].to_port
  ip_protocol       = var.ntier_bastion.ingress[count.index].ip_protocol
  cidr_ipv4         = var.ntier_bastion.ingress[count.index].cidr_ipv4
}

resource "aws_vpc_security_group_egress_rule" "bastion_egress" {
  security_group_id = aws_security_group.ntier_bastion.id
  from_port         = var.ntier_bastion.egress.from_port
  to_port           = var.ntier_bastion.egress.to_port
  ip_protocol       = var.ntier_bastion.egress.ip_protocol
  cidr_ipv4         = var.ntier_bastion.egress.cidr_ipv4
}

resource "aws_security_group" "ntier_app" {
  name        = var.ntier_app.Name
  description = var.ntier_app.description #"Allow ALB traffic and Bastion SSH"
  vpc_id      = aws_vpc.ntier.id
  tags = {
    Name = var.ntier_app.Name
  }
}

# resource "aws_vpc_security_group_ingress_rule" "app_ingress" {
#   count                        = length(var.ntier_app.ingress)
#   security_group_id            = aws_security_group.ntier_app.id
#   referenced_security_group_id = aws_security_group.ntier_alb.id
#   from_port                    = var.ntier_app.ingress[count.index].from_port
#   to_port                      = var.ntier_app.ingress[count.index].to_port
#   description                  = var.ntier_app.ingress[count.index].description
#   ip_protocol                  = var.ntier_app.ingress[count.index].ip_protocol
# }
resource "aws_vpc_security_group_ingress_rule" "app_http" {
  security_group_id            = aws_security_group.ntier_app.id
  referenced_security_group_id = aws_security_group.ntier_alb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  description                  = "HTTP from ALB"
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh" {
  security_group_id            = aws_security_group.ntier_app.id
  referenced_security_group_id = aws_security_group.ntier_bastion.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  description                  = "SSH from Bastion"
}

resource "aws_vpc_security_group_egress_rule" "app_egress" {
  security_group_id = aws_security_group.ntier_app.id
  cidr_ipv4         = var.ntier_app.egress.cidr_ipv4
  from_port         = var.ntier_app.egress.from_port
  to_port           = var.ntier_app.egress.to_port
  ip_protocol       = var.ntier_app.egress.ip_protocol
}

resource "aws_security_group" "ntier_db" {
  name        = var.ntier_db.Name
  description = var.ntier_db.description #"Allow ALB traffic and Bastion SSH"
  vpc_id      = aws_vpc.ntier.id
  tags = {
    Name = var.ntier_db.Name
  }
}
resource "aws_vpc_security_group_ingress_rule" "db_ingress" {
  count                        = length(var.ntier_db.ingress)
  security_group_id            = aws_security_group.ntier_db.id
  referenced_security_group_id = aws_security_group.ntier_app.id
  description                  = var.ntier_db.ingress[count.index].description
  from_port                    = var.ntier_db.ingress[count.index].from_port
  to_port                      = var.ntier_db.ingress[count.index].to_port

  ip_protocol = var.ntier_db.ingress[count.index].ip_protocol
}

resource "aws_vpc_security_group_egress_rule" "db_egress" {
  security_group_id = aws_security_group.ntier_db.id
  cidr_ipv4         = var.ntier_db.egress.cidr_ipv4
  from_port         = var.ntier_db.egress.from_port
  to_port           = var.ntier_db.egress.to_port
  ip_protocol       = var.ntier_db.egress.ip_protocol
}
