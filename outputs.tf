
output "vpc_a_id" {
  value = aws_vpc.project_a_vpc.id
}

output "vpc_b_id" {
  value = aws_vpc.project_b_vpc.id
}

output "vpc_peering_id" {
  value = aws_vpc_peering_connection.peer_a_to_b.id
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.example_tgw.id
}
