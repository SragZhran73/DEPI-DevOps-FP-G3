
provider "aws" {
  region = "us-east-1"   # dont change the region
}

# dh resource bs lel existing vpc ele 3leha el jenkins w hyb2a 3leha kol 7aga 
data "aws_vpc" "my_existing_vpc" {
  id = "vpc-02501dbf1387f15c0"  
}
