
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                    = "DEPI_control_cluster"
  cluster_endpoint_public_access  = true # Keep the control plane private
  cluster_endpoint_private_access = true  # Private access only

 cluster_addons = {
    coredns                = {most_recent = true}
    kube-proxy             = {most_recent = true}
    vpc-cni                = {most_recent = true}
  }

  vpc_id = aws_vpc.eks_vpc.id
  # Use private subnets for worker nodes and control plane
  subnet_ids               = [aws_subnet._prSubnet_1.id, aws_subnet._prSubnet_2.id] # For worker nodes
  control_plane_subnet_ids = [aws_subnet._prSubnet_1.id, aws_subnet._prSubnet_2.id] # For the control plane
  


eks_managed_node_group_defaults = {
  ami_type = "AL2023_x86_64_STANDARD"
  instance_types = ["t2.medium"]
  attach_cluster_primary_security_group = true
}

 eks_managed_node_groups = {
    depi_cluster = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    tags= {
        ExtraTag = "DEPI_PROJECT_CLUSTER"
    }
    }
  
  }



  # # Fargate Profile Configuration for backend and frontend
  # fargate_profiles = {
  #   fargate_profiles  = {
  #     name = "fargate-default"
  #     selectors = [
  #       {
  #         namespace = "default"},
  #         {
  #         namespace = "kube-system"
  #       }
  #     ]
  #   }
  # }


  tags = {
    project = "eks-cluster"
  }
}




