# VPCs
resource "aws_vpc" "r_VPC" {
  #checkov:skip=CKV_AWS_11:Ensure VPC flow logging is enabled in all VPCs
  #checkov:skip=CKV2_AWS_11:Flow logs are configured separately using the 'aws_flow_log.r_FlowLog' resource in VPC
  #checkov:skip=CKV2_AWS_12:A default security will automatically be created by Terraform that restricts all traffic.
  for_each             = var.Resource_Network.VPC
  cidr_block           = each.value.cidr_block
  enable_dns_hostnames = each.value.enable_dns_hostnames == "false" ? false : true
  enable_dns_support   = each.value.enable_dns_support == "false" ? false : true

  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )
}


resource "aws_vpc_dhcp_options" "r_DHCPOptions" {
  for_each            = var.Resource_Network.DHCPOptions
  domain_name         = each.value.domain_name
  domain_name_servers = split(",", each.value.dns)
  ntp_servers         = split(",", each.value.ntp_servers)
  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )

}

#########################
# DHCP Option Association
#########################

resource "aws_vpc_dhcp_options_association" "r_DHCPAssocitaion" {
  for_each        = var.Resource_Network.DHCPAssociation
  vpc_id          = aws_vpc.r_VPC["${each.value.vpc_resource_key}"].id
  dhcp_options_id = aws_vpc_dhcp_options.r_DHCPOptions["${each.value.dhcp_resource_key}"].id

}

# Default ACLs for VPCs
resource "aws_default_network_acl" "r_DefaultNetworkACL" {
  for_each               = var.Resource_Network.VPC
  default_network_acl_id = aws_vpc.r_VPC["${each.key}"].default_network_acl_id

  dynamic "ingress" {
    for_each = var.Resource_Network.DefaultNetworkACL_Ingress
    content {
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      action          = ingress.value.action
      cidr_block      = ingress.value.cidr_block == "null" ? null : ingress.value.cidr_block
      ipv6_cidr_block = ingress.value.ipv6_cidr_block == "null" ? null : ingress.value.ipv6_cidr_block
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = var.Resource_Network.DefaultNetworkACL_Egress
    content {
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      action          = egress.value.action
      cidr_block      = egress.value.cidr_block == "null" ? null : egress.value.cidr_block
      ipv6_cidr_block = egress.value.ipv6_cidr_block == "null" ? null : egress.value.ipv6_cidr_block
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

# Subnets
resource "aws_subnet" "r_Subnet" {
  #checkov:skip=CKV_AWS_130:Ensure VPC subnets do not assign public IP by default
  for_each                = var.Resource_Network.Subnet
  vpc_id                  = aws_vpc.r_VPC["${each.value.vpc_resource_key}"].id
  availability_zone       = each.value.availability_zone
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  #ipv6_cidr_block = each.value.ipv6_cidr_block
  #assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation
  assign_ipv6_address_on_creation = false

  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )
}

# Route Tables
resource "aws_route_table" "r_RouteTable" {
  #checkov:skip=CKV2_AWS_44:Ensure AWS route table with VPC peering does not contain routes overly permissive to all traffic
  for_each = var.Resource_Network.RouteTable
  vpc_id   = aws_vpc.r_VPC["${each.value.vpc_resource_key}"].id

  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )
}

# Routes
resource "aws_route" "r_Route" {
  for_each       = var.Resource_Network.Route
  route_table_id = aws_route_table.r_RouteTable["${each.value.route_table_resource_key}"].id
  # One of the following destination arguments must be supplied
  destination_cidr_block      = contains(keys(each.value), "destination_cidr_block") ? each.value.destination_cidr_block : null           # (Optional) The destination CIDR block.
  destination_ipv6_cidr_block = contains(keys(each.value), "destination_ipv6_cidr_block") ? each.value.destination_ipv6_cidr_block : null # (Optional) The destination IPv6 CIDR block.
  destination_prefix_list_id  = contains(keys(each.value), "destination_prefix_list_id") ? each.value.destination_prefix_list_id : null   # (Optional) The ID of a managed prefix list destination.

  # One of the following target arguments must be supplied
  carrier_gateway_id     = contains(keys(each.value), "carrier_gateway_id") ? each.value.carrier_gateway_id : null         # (Optional) Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone.
  core_network_arn       = contains(keys(each.value), "core_network_arn") ? each.value.core_network_arn : null             # (Optional) The Amazon Resource Name (ARN) of a core network.
  egress_only_gateway_id = contains(keys(each.value), "egress_only_gateway_id") ? each.value.egress_only_gateway_id : null # (Optional) Identifier of a VPC Egress Only Internet Gateway.
  #code needs to be changed for gateway_id and nat_gateway_id , although we don't use gateways and nat gateways at each vpc level
  #since this is at central cwan level but still if we need then there will be 2 runs of this code to accomplish route addition.
  gateway_id                = contains(keys(each.value), "gateway_id") ? each.value.gateway_id : null                               # (Optional) Identifier of a VPC internet gateway or a virtual private gateway.
  nat_gateway_id            = contains(keys(each.value), "nat_gateway_id") ? each.value.nat_gateway_id : null                       # (Optional) Identifier of a VPC NAT gateway.
  local_gateway_id          = contains(keys(each.value), "local_gateway_id") ? each.value.local_gateway_id : null                   # (Optional) Identifier of a Outpost local gateway.
  network_interface_id      = contains(keys(each.value), "network_interface_id") ? each.value.network_interface_id : null           # (Optional) Identifier of an EC2 network interface.
  transit_gateway_id        = contains(keys(each.value), "transit_gateway_id") ? each.value.transit_gateway_id : null               # (Optional) Identifier of an EC2 Transit Gateway.
  vpc_endpoint_id           = contains(keys(each.value), "vpc_endpoint_id") ? each.value.vpc_endpoint_id : null                     # (Optional) Identifier of a VPC Endpoint.
  vpc_peering_connection_id = contains(keys(each.value), "vpc_peering_connection_id") ? each.value.vpc_peering_connection_id : null # (Optional) Identifier of a VPC peering connection.
}


resource "aws_route" "r_Igw_Route" {
  for_each       = var.Resource_Network.InternetGatewayRoute
  route_table_id = aws_route_table.r_RouteTable["${each.value.route_table_resource_key}"].id
  # One of the following destination arguments must be supplied
  destination_cidr_block      = contains(keys(each.value), "destination_cidr_block") ? each.value.destination_cidr_block : null           # (Optional) The destination CIDR block.
  destination_ipv6_cidr_block = contains(keys(each.value), "destination_ipv6_cidr_block") ? each.value.destination_ipv6_cidr_block : null # (Optional) The destination IPv6 CIDR block.
  destination_prefix_list_id  = contains(keys(each.value), "destination_prefix_list_id") ? each.value.destination_prefix_list_id : null   # (Optional) The ID of a managed prefix list destination.

  gateway_id = aws_internet_gateway.r_InternetGateway["${each.key}"].id
}

resource "aws_route" "r_NatGW_Route" {
  for_each       = var.Resource_Network.NATGatewayRoute
  route_table_id = aws_route_table.r_RouteTable["${each.value.route_table_resource_key}"].id
  # One of the following destination arguments must be supplied
  destination_cidr_block      = contains(keys(each.value), "destination_cidr_block") ? each.value.destination_cidr_block : null           # (Optional) The destination CIDR block.
  destination_ipv6_cidr_block = contains(keys(each.value), "destination_ipv6_cidr_block") ? each.value.destination_ipv6_cidr_block : null # (Optional) The destination IPv6 CIDR block.
  destination_prefix_list_id  = contains(keys(each.value), "destination_prefix_list_id") ? each.value.destination_prefix_list_id : null   # (Optional) The ID of a managed prefix list destination.

  nat_gateway_id = aws_nat_gateway.r_NATGateway["${each.key}"].id
}


# Route Table Association (To Subnet)
resource "aws_route_table_association" "r_RouteTableAssoc" {
  for_each = var.Resource_Network.Subnet
  depends_on = [ # Make sure the route tables and routes exist first
    aws_route_table.r_RouteTable,
    aws_route.r_Route
  ]

  subnet_id      = aws_subnet.r_Subnet["${each.key}"].id
  route_table_id = aws_route_table.r_RouteTable["${each.value.route_table_resource_key}"].id
}

# EIP
resource "aws_eip" "r_EIP" {
  #checkov:skip=CKV2_AWS_19:Ensure that all EIP addresses allocated to a VPC are attached to EC2 instances
  for_each = var.Resource_Network.EIP
  #domain   = "vpc"
  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )
}

# NAT Gateway
resource "aws_nat_gateway" "r_NATGateway" {
  for_each = var.Resource_Network.NATGateway

  allocation_id = aws_eip.r_EIP["${each.value.eip_resource_key}"].id
  subnet_id     = aws_subnet.r_Subnet["${each.value.subnet_resource_key}"].id

  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )
}

# Internet Gateway
resource "aws_internet_gateway" "r_InternetGateway" {
  for_each = var.Resource_Network.InternetGateway

  vpc_id = aws_vpc.r_VPC["${each.value.vpc_resource_key}"].id

  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags
  )
}

/*
locals {
  is_cw_logs = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs"
}



# Core Network's attachment acceptance (if required)
#resource "aws_networkmanager_attachment_accepter" "cwan" {
 # count = length(var.cwan_subnet_cidr_blocks) > 0 && var.attach_cwan ? 1 : 0

  #attachment_id   = aws_networkmanager_vpc_attachment.cwan[0].id
  #attachment_type = "VPC"
#}


#data block to get the role details from the name provided.
data "aws_iam_role" "flowLogsRole" {
  count = var.enable_flow_logs && local.is_cw_logs && var.flow_logs_iam_role != null ? 1 : 0
  name  = var.flow_logs_iam_role
}
# Creating cloudwatch log_group to capture the vpc flow logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.enable_flow_logs && local.is_cw_logs ? 1 : 0

  name              = var.flow_logs_log_group_name
  retention_in_days = var.flow_logs_retention_in_days
  tags = merge(
    {
      "Name" = var.flow_logs_log_group_name
    },
    var.Tags,
  )
}

# Creating flow log for vpc.
resource "aws_flow_log" "vpc_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  log_destination_type = var.flow_logs_destination_type
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs[0].arn
  iam_role_arn         = data.aws_iam_role.flowLogsRole[0].arn
  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  tags = merge(
    {
      "Name" = var.flow_logs_log_group_name
    },
    var.Tags,
  )
}
*/

# Creating cloudwatch log_group to capture the vpc flow logs
resource "aws_cloudwatch_log_group" "r_CloudWatch_LogGroup" {
  for_each          = var.Resource_Network.CloudWatch_LogGroup
  name              = format("%s", each.value.name)
  retention_in_days = each.value.retention_in_days
  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags,
  )
}



# Data block to get the role details from the name provided.
data "aws_iam_role" "d_IAMRole_FlowLog" {
  for_each = var.Resource_Network.FlowLog
  name     = each.value.iam_role_name
}



# Creating flow log for vpc.
resource "aws_flow_log" "r_FlowLog" {
  for_each = var.Resource_Network.FlowLog



  log_destination_type = each.value.log_destination_type
  log_destination      = aws_cloudwatch_log_group.r_CloudWatch_LogGroup["${each.value.log_group_resource_key}"].arn
  iam_role_arn         = data.aws_iam_role.d_IAMRole_FlowLog["${each.key}"].arn
  vpc_id               = aws_vpc.r_VPC["${each.value.vpc_resource_key}"].id
  traffic_type         = "ALL"
  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.Tags,
  )
}