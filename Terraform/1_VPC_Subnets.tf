resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "EKS-VPC"
    Project = "DEPI"
  }
}

resource "aws_subnet" "_pubSubnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  availability_zone       = "${var.Region}a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

tags = {
  Name                              = "EKS-PublicSubnet"
  Project                           = "DEPI"
  "kubernetes.io/role/internal-elb"    = "1"
  "kubernetes.io/cluster/DEPI_control_cluster"  = "shared"   # Replace 'clustername' with your actual cluster name
}

}

resource "aws_subnet" "_pubSubnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  availability_zone       = "${var.Region}a"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true

tags = {
  Name                              = "EKS-PublicSubnet"
  Project                           = "DEPI"
  "kubernetes.io/role/internal-elb"    = "1"
  "kubernetes.io/cluster/DEPI_control_cluster"  = "shared"   # Replace 'clustername' with your actual cluster name
}

}


resource "aws_subnet" "_prSubnet_1" {
  availability_zone = "${var.Region}a"
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name    = "EKS-PrivateSubnet_1"
    Project = "DEPI"
    "kubernetes.io/role/internal-elb"   = "1"
    "kubernetes.io/cluster/DEPI_control_cluster"  = "shared" 
  }

}

resource "aws_subnet" "_prSubnet_2" {
  availability_zone = "${var.Region}b"
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.3.0/24"

  tags = {
    Name    = "EKS-PrivateSubnet_2"
    Project = "DEPI"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/cluster/DEPI_control_cluster"  = "shared"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_route_table_assoc_1" {
  subnet_id      = aws_subnet._pubSubnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_assoc_2" {
  subnet_id      = aws_subnet._pubSubnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_eip" "nat" {

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet._pubSubnet_1.id

  tags = {
    Name = "eks-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}



resource "aws_route_table" "privae_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "privateRoute-nat"
  }
}



resource "aws_route_table_association" "_prRoute1" {
  route_table_id = aws_route_table.privae_route_table.id
  subnet_id      = aws_subnet._prSubnet_1.id
}
resource "aws_route_table_association" "_prRoute2" {
  route_table_id = aws_route_table.privae_route_table.id
  subnet_id      = aws_subnet._prSubnet_2.id
}
