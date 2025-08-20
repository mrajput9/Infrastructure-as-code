module "m_SecurityGroup_Dev" {
  source         = "./modules/aws/infra/security-group"
  for_each       = var.Security_Groups_Dev
  sg_name        = each.value.sg_name
  sg_description = each.value.sg_description
  sg_rules       = each.value.sg_rules
  vpc_id         = module.m_VPC_ap-southeast-dev.r_VPC["${each.value.vpc_resource_key}"].id
  tags = merge(
    {
      "Name" = format("%s", each.value.sg_name)
    },
    var.Tags["${each.value.tag_resource_key}"]
  )
}
