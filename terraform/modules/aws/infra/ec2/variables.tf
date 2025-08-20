
variable "tags" {
  type        = map(string)
  description = "tags for the environemnt"
}

variable "name" {
  type        = string
  description = "The name to be used for the instance"
}
variable "instance_type" {
  type        = string
  description = "The instance type to use for the instance."
}
variable "nics" {
  type        = list(string)
  description = "A list of IDs of network interfaces to attach."
}
variable "ami_id" {
  type        = string
  description = "AMI to use for the instance."
}
variable "key_name" {
  type        = string
  description = "Key name of the Key Pair to use for the instance"
  default     = null
}
variable "security_groups" {
  type        = list(string)
  description = "A list of security group IDs to associate with."
  default     = null
}
variable "subnet_id" {
  type        = string
  description = "VPC Subnet ID to launch in."
  default     = null
}

variable "instance_profile" {
  type        = string
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  default     = null
}
variable "user_data" {
  type        = string
  description = "User data to provide when launching the instance. Do not pass gzip-compressed data via this argument."
  default     = null
}

variable "monitoring" {
  type        = bool
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  default     = true
}
variable "windows_root_volume_size" {
  type    = number
  default = 100
}
variable "windows_root_volume_type" {
  type    = string
  default = "gp3"
}

variable "volumes_attached" {
  type        = map(any)
  description = "Details of volume attached to the server"
  default     = {}
}
/*variable "windows_data_volume_size" {
  type = number
  default = 30
}
/*variable "windows_data_volume_type" {
  type = string
  default = "gp2"
}*/