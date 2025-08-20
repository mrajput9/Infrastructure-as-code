# Setup VPCs, subnets, route tables, and routes
module "m_VPC_ap-southeast-dev" {
  source           = "./modules/aws/infra/vpc" # 'modules' is copied by the build pipeline from the centralized module repo.
  Resource_Network = var.VPC_Dev
  Tags             = var.Tags.Primary
}
