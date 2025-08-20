# Placeholder file for Terraform code
/*
output "o_VPC_Primary" {
  value = module.m_VPC_Primary
}*/
output "available_sg_keys_dev" {
  value = keys(module.m_SecurityGroup_Dev)
}
