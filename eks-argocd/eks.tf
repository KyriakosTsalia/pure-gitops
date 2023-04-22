# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "19.13.1"

#   cluster_name    = "cluster-1"
#   cluster_version = "1.26"

#   cluster_endpoint_public_access  = true
#   cluster_endpoint_private_access = true

#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent = true
#     }
#   }

#   vpc_id                   = module.vpc.vpc_id
#   subnet_ids               = module.vpc.private_subnets
#   control_plane_subnet_ids = module.vpc.public_subnets

#   eks_managed_node_groups = {
#     group-1 = {
#       min_size     = 2
#       max_size     = 2
#       desired_size = 2
#       max_unavaileable = 1

#       instance_types = ["t3.small"]
#       capacity_type  = "SPOT" 
#       disk_size = 50
#     }
#   }
# }

# output "endpoint" {
#     value = module.eks.cluster_endpoint
# }
