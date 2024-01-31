#resource "aws_eip" "nat_a" {
#  domain = "vpc"
#
#  tags = {
#    Name = "${local.app_id}-eip_a"
#  }
#}
#
#resource "aws_nat_gateway" "nat_a" {
#  subnet_id     = "${aws_subnet.public_a.id}"
#  allocation_id = "${aws_eip.nat_a.id}"
#
#  tags = {
#    Name = "${local.app_id}-nat_a"
#  }
#}

# resource "aws_eip" "nat_c" {
#   domain = "vpc"
#
#   tags = {
#     Name = "${local.app_id}-eip_c"
#   }
# }
#
# resource "aws_nat_gateway" "nat_c" {
#   subnet_id     = "${aws_subnet.public_c.id}"
#   allocation_id = "${aws_eip.nat_c.id}"
#
#   tags = {
#     Name = "${local.app_id}-nat_c"
#   }
# }

# resource "aws_route" "private_c" {
#   destination_cidr_block = "0.0.0.0/0"
#   route_table_id         = "${aws_route_table.private_c.id}"
#   nat_gateway_id         = "${aws_nat_gateway.nat_c.id}"
# }

# resource "aws_route" "private_a" {
#   destination_cidr_block = "0.0.0.0/0"
#   route_table_id         = aws_route_table.private_a.id
#   nat_gateway_id         = aws_nat_gateway.nat_a.id
# }
