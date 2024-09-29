
# Define the provider
provider "aws" {
  region = "us-west-2"
}

# VPC for Project A
resource "aws_vpc" "project_a_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ProjectA-VPC"
  }
}

# VPC for Project B
resource "aws_vpc" "project_b_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "ProjectB-VPC"
  }
}

# Public Subnet for Project A
resource "aws_subnet" "project_a_public_subnet" {
  vpc_id            = aws_vpc.project_a_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "ProjectA-PublicSubnet"
  }
}

# Public Subnet for Project B
resource "aws_subnet" "project_b_public_subnet" {
  vpc_id            = aws_vpc.project_b_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "ProjectB-PublicSubnet"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peer_a_to_b" {
  vpc_id        = aws_vpc.project_a_vpc.id
  peer_vpc_id   = aws_vpc.project_b_vpc.id
  auto_accept   = true
  
  tags = {
    Name = "Peer-ProjectA-to-ProjectB"
  }
}

# Route Table for Project A to allow traffic to Project B
resource "aws_route" "project_a_to_b_route" {
  route_table_id         = aws_vpc.project_a_vpc.default_route_table_id
  destination_cidr_block = aws_vpc.project_b_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_to_b.id
}

# Route Table for Project B to allow traffic to Project A
resource "aws_route" "project_b_to_a_route" {
  route_table_id         = aws_vpc.project_b_vpc.default_route_table_id
  destination_cidr_block = aws_vpc.project_a_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_a_to_b.id
}

# Security Group for Project A instances
resource "aws_security_group" "project_a_sg" {
  vpc_id = aws_vpc.project_a_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.project_b_vpc.cidr_block] # Allow traffic only from Project B VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ProjectA-SG"
  }
}

# Security Group for Project B instances
resource "aws_security_group" "project_b_sg" {
  vpc_id = aws_vpc.project_b_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.project_a_vpc.cidr_block] # Allow traffic only from Project A VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ProjectB-SG"
  }
}

# Create a Transit Gateway
resource "aws_ec2_transit_gateway" "example_tgw" {
  description = "Example Transit Gateway"
  amazon_side_asn = 64512

  tags = {
    Name = "Example-Transit-Gateway"
  }
}

# Attach VPC A to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "project_a_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.example_tgw.id
  vpc_id             = aws_vpc.project_a_vpc.id
  subnet_ids         = [aws_subnet.project_a_public_subnet.id]

  tags = {
    Name = "ProjectA-TGW-Attachment"
  }
}

# Attach VPC B to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "project_b_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.example_tgw.id
  vpc_id             = aws_vpc.project_b_vpc.id
  subnet_ids         = [aws_subnet.project_b_public_subnet.id]

  tags = {
    Name = "ProjectB-TGW-Attachment"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "EC2AccessRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "allow_s3_access_policy" {
  name = "AllowS3AccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Resource = [
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.allow_s3_access_policy.arn
}