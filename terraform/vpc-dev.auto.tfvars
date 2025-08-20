# Placeholder file for Terraform code.
VPC_Dev = {
  VPC = { # This is the resource type
    # VPC for Dev Environment
    Primary_Dev = {                                              # This is the resource 'key'
      name                 = "vpc-SailPnt-AU-Up-Dev-southeast-2" # Name for the vpc
      cidr_block           = "10.205.65.64/26"                   # The IPv4 CIDR block for the VPC. 
      enable_dns_hostnames = "true"                              # A boolean flag to enable/disable DNS hostnames in the VPC. Set to "false" to make false, otherwise value will be true.
      enable_dns_support   = "true"                              # A boolean flag to enable/disable DNS support in the VPC. Set to "false" to make false, otherwise value will be true.
    }
  }
  DefaultNetworkACL_Ingress = { # This is the resource type 
    # Default NACL for Dev Environment
    Primary_Dev = {                    # This is the resource 'key'
      vpc_resource_key = "Primary_Dev" # This is the VPC 'key'
      name             = "Default"
      protocol         = "all"
      rule_no          = "100"
      action           = "allow"
      cidr_block       = "0.0.0.0/0"
      ipv6_cidr_block  = "null"
      from_port        = "0"
      to_port          = "0"
    }
  }
  DefaultNetworkACL_Egress = { # This is the resource type 
    # Default NACL for Dev Environment
    Primary_Dev = {                    # This is the resource 'key'
      vpc_resource_key = "Primary_Dev" # This is the VPC 'key'
      name             = "Default"
      protocol         = "all"
      rule_no          = "100"
      action           = "allow"
      cidr_block       = "0.0.0.0/0"
      ipv6_cidr_block  = "null"
      from_port        = "0"
      to_port          = "0"
    }
  }

  Subnet = { # This is the resource type
    # Subnet's for us-east-1a availability zone(Dev Environment)
    Dev_App-2a = {                                       # This is the resource 'key'
      vpc_resource_key         = "Primary_Dev"           # This is the VPC 'key'
      route_table_resource_key = "PrivateRouteTable_Dev" # This is the Route Table 'key'
      availability_zone        = "us-east-1a"
      name                     = "snet-SailPnt-AU-Up-Dev-App-southeast-2a"
      cidr_block               = "10.205.65.64/28"
      map_public_ip_on_launch  = "false"
    }
    Dev_CloudWAN-2a = {                        # This is the resource 'key'
      vpc_resource_key         = "Primary_Dev" # This is the VPC 'key'
      route_table_resource_key = "CWAN_Dev"    # This is the Route Table 'key'
      availability_zone        = "us-east-1a"
      name                     = "snet-SailPnt-AU-Up-Dev-CloudWAN-southeast-2a"
      cidr_block               = "10.205.65.80/28"
      map_public_ip_on_launch  = "false"
    }
    # Subnet for ap-southeast-2b availability zone(Dev Environment)
    Dev_App-2b = {                                       # This is the resource 'key'
      vpc_resource_key         = "Primary_Dev"           # This is the VPC 'key'
      route_table_resource_key = "PrivateRouteTable_Dev" # This is the Route Table 'key'
      availability_zone        = "us-east-1b"
      name                     = "snet-SailPnt-AU-Up-Dev-App-southeast-2b"
      cidr_block               = "10.205.65.96/28"
      map_public_ip_on_launch  = "false"
    }
    Dev_CloudWAN-2b = {                        # This is the resource 'key'
      vpc_resource_key         = "Primary_Dev" # This is the VPC 'key'
      route_table_resource_key = "CWAN_Dev"    # This is the Route Table 'key'
      availability_zone        = "us-east-1b"
      name                     = "snet-SailPnt-AU-Up-Dev-CloudWAN-southeast-2b"
      cidr_block               = "10.205.65.112/28"
      map_public_ip_on_launch  = "false"
    }
  }

  RouteTable = { # This is the resource type  
    # RouteTable for Dev Environment
    CWAN_Dev = {                       # This is the 'key' that will be used when referring to the resource in Terraform's state file
      vpc_resource_key = "Primary_Dev" # This is the VPC 'key'
      name             = "rt-SailPnt-AU-Up-Dev-CWAN-southeast-2"
    }
    PrivateRouteTable_Dev = {          # This is the 'key' that will be used when referring to the resource in Terraform's state file
      vpc_resource_key = "Primary_Dev" # This is the VPC 'key'
      name             = "rt-SailPnt-AU-Up-Dev-PrivateSubnet-southeast-2"
    }
  }
  CloudWatch_LogGroup = { # This is the resource type 
    # CloudWatch LogGroup for Dev Environment
    Primary_Dev = { # This is the resource 'key'
      name              = "Dev_flow-logs"
      retention_in_days = "365"
    }
  }
  FlowLog = { # This is the resource type  
     # FlowLog for Dev Environment
    #  Primary_Dev = {                          # This is the resource 'key'
    #    vpc_resource_key       = "Primary_Dev" # This is the VPC 'key'
    #    log_group_resource_key = "Primary_Dev" # This is the CloudWatch_LogGroup 'key'
    #    name                   = "Dev_flow-logs"
    #    iam_role_name          = "flow-logs-role" # The name of the IAM Role which will be used by VPC Flow Logs if vpc_log_destination_type is cloud-watch-logs.
    #    log_destination_type   = "cloud-watch-logs"
    #  }
  }
  Route = {
     # Route for Dev Environment
#      CWAN-to-CloudWAN_Dev = {
#        route_table_resource_key = "CWAN_Dev"
#        destination_cidr_block   = "0.0.0.0/0"
#        core_network_arn         = "arn:aws:networkmanager::431865610427:core-network/core-network-03183ad1a92850a94"
#  }
#      PrivateSubnet-to-CloudWAN_Dev = {
#        route_table_resource_key = "PrivateRouteTable_Dev"
#        destination_cidr_block   = "0.0.0.0/0"
#        core_network_arn         = "arn:aws:networkmanager::431865610427:core-network/core-network-03183ad1a92850a94"
#      }
  }

  DHCPOptions = {
    # DHCPOptions for Dev Environment
    Primary_Dev = {                              # This is the resource 'key'
      domain_name = "local"                      # Do not put any domains ('local' effectively does this). All DNS queries should be fully qualified.
      dns         = "10.205.36.10,10.205.36.140" # These are the AU DNS server IP's; use commas to separate multiple IP addresses; do not include spaces.
      ntp_servers = "169.254.169.123"            # (Optional) List of NTP servers to configure; 169.254.169.123 = AWS' NTP service. See https://aws.amazon.com/blogs/aws/keeping-time-with-amazon-time-sync-service/
      name        = "DHCP-AU-Dev-SailPnt"
    }
  }
  DHCPAssociation = {
    # DHCPAssociation for Dev Environment
    Primary_Dev = {                     # This is the resource 'key'
      vpc_resource_key  = "Primary_Dev" # This is the VPC 'key'
      dhcp_resource_key = "Primary_Dev" # This is the DHCP option set 'key'      
    }
  }
  EIP                  = {}
  NATGateway           = {}
  InternetGateway      = {}
  InternetGatewayRoute = {}
  NATGatewayRoute      = {}
}