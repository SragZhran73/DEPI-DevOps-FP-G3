resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.1.0/24" # Public subnet CIDR block
  availability_zone = "us-east-1a"  # Specify the availability zone

  map_public_ip_on_launch = true # Ensures public instances get a public IP

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
  }
}
