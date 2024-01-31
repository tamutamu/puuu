output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "public_a_id" {
  value = aws_subnet.public_a.id
}

output "public_c_id" {
  value = aws_subnet.public_c.id
}

output "private_a_id" {
  value = aws_subnet.private_a.id
}

output "private_c_id" {
  value = aws_subnet.private_c.id
}

output "route_table_private_a_id" {
  value = aws_route_table.private_a.id
}

output "route_table_private_c_id" {
  value = aws_route_table.private_c.id
}
