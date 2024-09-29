
resource "aws_ec2_transit_gateway" "example_tgw" {
  description = "Example Transit Gateway"
  amazon_side_asn = 64512

  tags = {
    Name = "Example-Transit-Gateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "project_a_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.example_tgw.id
  vpc_id             = aws_vpc.project_a_vpc.id
  subnet_ids         = [aws_subnet.project_a_public_subnet.id]

  tags = {
    Name = "ProjectA-TGW-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "project_b_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.example_tgw.id
  vpc_id             = aws_vpc.project_b_vpc.id
  subnet_ids         = [aws_subnet.project_b_public_subnet.id]

  tags = {
    Name = "ProjectB-TGW-Attachment"
  }
}
