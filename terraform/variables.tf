# variable for Region
variable "Region_Primary" {
  type        = string
  description = "The primary region"
  default     = "__CrawfordDevOps_Terraform_AWS_DefaultRegion__" # Token that will be replaced during the pipeline execution.
}

# variable for VPC
variable "VPC_Dev" {
  type        = map(any)
  description = "Map of objects for creating VPCs in the primary region"
  nullable    = false
}
# variable for Tags
variable "Tags" {
  description = "Map of objects for setting tag values."
  type        = map(any)
}
variable "Resource_EC2_DEV" {
  type        = map(any)
  description = "Map of objects for creating config"
}
variable "volumes_attached_dev" {
  default     = null
  type        = map(any)
  description = "Details of volume attached to the server"
}
# variable for Security groups
variable "Security_Groups_Dev" {
  description = "Map of objects for creating security groups"
  type        = map(any)
}


