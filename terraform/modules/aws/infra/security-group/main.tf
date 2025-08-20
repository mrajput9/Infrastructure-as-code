resource "aws_security_group" "security_group" {
  #checkov:skip=CKV2_AWS_5:Security groups are deliberately created separately from the resources they are attached to
  #checkov:skip=CKV_AWS_24:Ensure no security groups allow ingress from 0.0.0.0:0 to port 22
  #checkov:skip=CKV_AWS_25:Ensure no security groups allow ingress from 0.0.0.0:0 to port 3389
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = var.sg_name
    },
  )
}


resource "aws_security_group_rule" "security_group_rule" {
  #checkov:skip=CKV_AWS_24:Ensure no security groups allow ingress from 0.0.0.0:0 to port 22
  #checkov:skip=CKV_AWS_25:Ensure no security groups allow ingress from 0.0.0.0:0 to port 3389
  #checkov:skip=CKV_AWS_260:Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
  for_each          = var.sg_rules
  type              = each.value.type
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr
  description       = each.value.description
  security_group_id = aws_security_group.security_group.id
}


