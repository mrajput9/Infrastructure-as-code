
module "m_EC2_ap-southeast-dev" {
  source                   = "./modules/aws/infra/ec2"
  for_each                 = var.Resource_EC2_DEV.EC2_Instance
  ami_id                   = each.value.ami_id
  instance_type            = each.value.instance_type
  windows_root_volume_size = each.value.windows_root_volume_size
  key_name                 = each.value.key_name
  name                     = each.value.name
  instance_profile         = each.value.instance_profile == "null" ? null : each.value.instance_profile
  monitoring               = each.value.monitoring == "false" ? false : true
  user_data                = each.value.user_data == "null" ? null : file("${each.value.user_data}")
  volumes_attached         = each.value.attached_volume_resource_key == "null" ? null : var.volumes_attached_dev["${each.value.attached_volume_resource_key}"]
  nics = flatten([
    for res_key in split(",", each.value.nic_resource_keys) : [
      aws_network_interface.r_NetworkInterface_Dev[res_key].id
    ]
  ])
  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags["${each.value.tag_resource_key}"]
  )
}

# Create network interfaces (for the EC2 instances)
resource "aws_network_interface" "r_NetworkInterface_Dev" {
  for_each  = var.Resource_EC2_DEV.Network_Interface
  subnet_id = module.m_VPC_ap-southeast-dev.r_Subnet["${each.value.subnet_resource_key}"].id
  security_groups = flatten([
    for res_key in split(",", each.value.sg_resource_keys) : [
      module.m_SecurityGroup_Dev[res_key].id
    ]
  ])
  private_ips = split(",", each.value.private_ips)
  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags["${each.value.tag_resource_key}"]
  )
}



