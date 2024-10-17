
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                    = "DEPI_control_cluster"
  cluster_endpoint_public_access  = false # Keep the control plane private
  cluster_endpoint_private_access = true  # Private access only

  vpc_id = aws_vpc.eks_vpc.id

  # Use private subnets for worker nodes and control plane
  subnet_ids               = [aws_subnet._prSubnet_1.id, aws_subnet._prSubnet_2.id] # For worker nodes
  control_plane_subnet_ids = [aws_subnet._prSubnet_1.id, aws_subnet._prSubnet_2.id] # For the control plane

  # Fargate Profile Configuration for backend and frontend
  fargate_profiles = {
    frontend = {
      name = "fargate-frontend"
      selectors = [
        {
          namespace = "frontend"
          labels = {
            app = "frontend"
          }
        }
      ]
    }

    backend = {
      name = "fargate-backend"
      selectors = [
        {
          namespace = "backend"
          labels = {
            app = "backend"
          }
        }
      ]
    }
  }


  tags = {
    project = "eks-cluster"
  }
}




