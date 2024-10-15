data "aws_route_table" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.my_existing_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["public-route-table"] # Ensure your route table is tagged as 'public-route-table'
  }
}
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.my_existing_vpc.id

  tags = {
    Name = "private-route-table"
  }
}


resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# Associate private_subnet_2 with private-route-table
resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}