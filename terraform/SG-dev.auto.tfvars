Security_Groups_Dev = {
  Kush = {
    sg_name          = "SailPoint SG Dev"
    vpc_resource_key = "Primary_Dev" # This is the resource 'key'
    sg_description   = "Security Group for SailPoint App Specific"
    tag_resource_key = "Primary" # This is a Tags resource 'key'.
    sg_rules = {

      Egress-HTTPS-IN = {
        from        = 443
        to          = 443
        protocol    = "tcp"
        cidr        = ["0.0.0.0/0"] 
        type        = "egress"
        description = "CRL downloads and general patching"
      }
  }
  BaseLineSG = {
    sg_name          = "SailPoint BaseLineSG"
    vpc_resource_key = "Primary_Dev" # This is the resource 'key'
    sg_description   = "Baseline Security Group"
    tag_resource_key = "Primary" # This is a Tags resource 'key'.
  }

  sg_rules = {
      #Row28
      Egress-HTTPS-IN = {
        from        = 443
        to          = 443
        protocol    = "tcp"
        cidr        = ["0.0.0.0/0"] 
        type        = "egress"
        description = "CRL downloads and general patching"
      }
  }

  }
}