# Fetch the existing VPC
data "aws_vpc" "my_existing_vpc" {
  id = "vpc-02501dbf1387f15c0"
}