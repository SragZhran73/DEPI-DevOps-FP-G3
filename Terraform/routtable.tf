# Create an Internet Gateway
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "my-internet-gateway"
  }
}
# Create a new public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks-vpc.id

  # Define the routes for the public route table
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Create a private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "private-route-table"
  }
}

# Associate the private subnets with the private route table
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}
