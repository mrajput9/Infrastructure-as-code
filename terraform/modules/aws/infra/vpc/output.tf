output "r_VPC" {
  description = "VPC objects"
  value       = aws_vpc.r_VPC
}
output "r_DefaultNetworkACL" {
  description = "Default Network ACL objects"
  value       = aws_default_network_acl.r_DefaultNetworkACL
}
output "r_Subnet" {
  description = "Subnet objects"
  value       = aws_subnet.r_Subnet
}
output "r_RouteTable" {
  description = "RouteTable objects"
  value       = aws_route_table.r_RouteTable
}
output "r_Route" {
  description = "Route objects"
  value       = aws_route.r_Route
}
output "r_RouteTableAssoc" {
  description = "Route Table Association objects"
  value       = aws_route_table_association.r_RouteTableAssoc
}
output "r_EIP" {
  description = "EIP objects"
  value       = aws_eip.r_EIP
}
output "r_NATGateway" {
  description = "NAT Gateway objects"
  value       = aws_nat_gateway.r_NATGateway
}
output "r_InternetGateway" {
  description = "Internet Gateway objects"
  value       = aws_internet_gateway.r_InternetGateway
}