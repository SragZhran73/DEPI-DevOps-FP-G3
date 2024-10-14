provider "aws" {
  region = "us-east-1" # Don't change the region
}

# Fetch the existing VPC
data "aws_vpc" "my_existing_vpc" {
  id = "vpc-02501dbf1387f15c0"
}

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

# Associate private_subnet_1 with private-route-table
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# Associate private_subnet_2 with private-route-table
resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                   = "DEPI_control_cluster"
  cluster_endpoint_public_access = true
  vpc_id                         = data.aws_vpc.my_existing_vpc.id

  # Use both subnets from different AZs for worker nodes and control plane
  subnet_ids               = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  control_plane_subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]


  # Fargate Profile Configuration
  fargate_profiles = {
    default = {
      name = "fargate-default"
      selectors = [
        {
          namespace = "default"
        },
        {
          namespace = "kube-system"
        }
      ]
    }
  }

  tags = {
    project = "eks-cluster"
  }
}
