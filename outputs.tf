output "alb_dns" {
  value = aws_lb.ntier_alb.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "app_private_ips" {
  value = aws_instance.app[*].private_ip
}

output "rds_endpoint" {
  value = aws_db_instance.ntier_db.endpoint
}