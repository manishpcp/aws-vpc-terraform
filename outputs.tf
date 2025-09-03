output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "nat_gateways" {
  value = aws_nat_gateway.nat[*].id
}

output "internet_gateway" {
  value = aws_internet_gateway.igw.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}