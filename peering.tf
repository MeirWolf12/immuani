
resource "aws_vpc_peering_connection" "peer_a_to_b" {
  vpc_id        = aws_vpc.project_a_vpc.id
  peer_vpc_id   = aws_vpc.project_b_vpc.id
  auto_accept   = true
  
  tags = {
    Name = "Peer-ProjectA-to-ProjectB"
  }
}

resource "aws_route" "project_a_to_b_route" {
  route_table_id         = aws_vpc.project_a_vpc.default_route_table_id
  destination_cidr_block = aws_vpc.project_b_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_to_b.id
}

resource "aws_route" "project_b_to_a_route" {
  route_table_id         = aws_vpc.project_b_vpc.default_route_table_id
  destination_cidr_block = aws_vpc.project_a_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_to_b.id
}
