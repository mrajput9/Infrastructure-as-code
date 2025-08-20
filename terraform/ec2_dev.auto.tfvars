 
Resource_EC2_DEV = {
  EC2_Instance = {
    Dev_App-2a = {                                           
      ami_id                       = "ami-084568db4383264d4" 
      instance_type                = "t2.micro"              # Instance type
      windows_root_volume_size     = "50"                    # Linux root volume size
      key_name                     = "kushalProject"      # This is Key-pair from AWS account
      name                         = "DASE2SVRASPIQ1"        # This is the name of the instance 
      nic_resource_keys            = "Dev_app-2a"            # These are Network_Interface resource 'keys', separated by a comma.
      instance_profile             = "null"                  # TODO: Role and account number should be tokenized.
      monitoring                   = "true"                  # If true, the launched EC2 instance will have detailed monitoring enabled. 
      user_data                    = "null"                  # Path to file that should be uploaded for cloud init. Otherwise, set to "null"
      attached_volume_resource_key = "Dev_app-2a"            # These are volumes_attached resource 'keys', separated by a comma.
      tag_resource_key             = "Primary"               # This is a Tags resource 'key'.
    }
  }
  Network_Interface = {                                  # This is the resource type
    Dev_app-2a = {                                       # This is the resource 'key'
      name                = "nic-DASE2SVRASPIQ1"         # network interface with computer name with prefix/sufix nic
      private_ips         = "10.205.65.70"                 # A list of private IPs, separated by a comma.
      subnet_resource_key = "Dev_App-2a"                 # This is the subnet resource 'key'
      sg_resource_keys    = "SailPoint,BaseLineSG" # These are security group resource 'keys', separated by a comma.
      tag_resource_key    = "Primary"                    # This is a Tags resource 'key'.
    }
  }
}
volumes_attached_dev = {
  Dev_app-2a = {
    "volume2" = { name = "data_volume2", volume_size = 20, device_name = "/dev/sdg" }
  }
}

