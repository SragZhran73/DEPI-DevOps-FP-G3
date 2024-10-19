#--------------------------SG-for-the-ALB-mysql--------------------------#

resource "aws_security_group" "alb_sg" {
  name   = "eks-security-group"
  vpc_id = aws_vpc.eks_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "_HTTP" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
resource "aws_vpc_security_group_ingress_rule" "_HTTPS" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}


#--------------------------SG-for-the-RDS-mysql--------------------------#

resource "aws_security_group" "_SG_RDS" {
  vpc_id      = aws_vpc.eks_vpc.id
  description = "Allow SSH and HTTP/s traffic from any where"
  tags = {
    Name = "RDS-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "_msql_port" {
  security_group_id = aws_security_group._SG_RDS.id
  cidr_ipv4         = aws_vpc.eks_vpc.cidr_block
  #   referenced_security_group_id = aws_security_group._SG_EKS.id

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
}