# Fetch the existing subnet named 'public-subnet'
data "aws_subnet" "public_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my_existing_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["public-subnet"] # Ensure your subnet is tagged as 'public-subnet'
  }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id            = data.aws_vpc.my_existing_vpc.id
  cidr_block        = "172.31.150.0/24"
  availability_zone = "us-east-1a" # Specify the availability zone

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = data.aws_vpc.my_existing_vpc.id
  cidr_block        = "172.31.160.0/24"
  availability_zone = "us-east-1b" # Specify the availability zone

  tags = {
    Name = "private-subnet-2"
  }
}