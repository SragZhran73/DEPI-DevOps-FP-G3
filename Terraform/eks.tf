# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "19.15.1"

#   cluster_name                   = "DEPI_control_cluster"
#   cluster_endpoint_public_access = true
#   vpc_id                         = aws_vpc.eks-vpc.id

#   # Use both subnets from different AZs for worker nodes and control plane
#   subnet_ids               = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
#   control_plane_subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]


#   # Fargate Profile Configuration
#   fargate_profiles = {
#     default = {
#       name = "fargate-default"
#       selectors = [
#         {
#           namespace = "default"
#         },
#         {
#           namespace = "kube-system"
#         }
#       ]
#     }
#   }

#   tags = {
#     project = "eks-cluster"
#   }
# }
