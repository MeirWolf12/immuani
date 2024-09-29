
resource "aws_vpc" "project_a_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ProjectA-VPC"
  }
}

resource "aws_vpc" "project_b_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "ProjectB-VPC"
  }
}

resource "aws_subnet" "project_a_public_subnet" {
  vpc_id            = aws_vpc.project_a_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "ProjectA-PublicSubnet"
  }
}

resource "aws_subnet" "project_b_public_subnet" {
  vpc_id            = aws_vpc.project_b_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "ProjectB-PublicSubnet"
  }
}
