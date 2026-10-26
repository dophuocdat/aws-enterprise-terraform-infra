output "vpc_id" {
  description = "ID cua VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Danh sach ID cua 2 public Subnet (1a, 2b)"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "Dai IP thuc te cua 2 public Subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_ids" {
  description = "Danh sach ID cua 2 private Subnets (1a, 2b)"
  value       = aws_subnet.private[*].id
}

output "private_subnet_cidrs" {
  description = "Dai IP thuc te cua 2 private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "s3_endpoint_prefix_list" {
  description = "Prefix List ID cua S3 de cau hinh Security Grou Egress"
  value       = aws_vpc_endpoint.s3.prefix_list_id
}
