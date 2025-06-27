output "public_ips" {
  value = [for instance in aws_instance.oscardemo: instance.public_ip]
}

