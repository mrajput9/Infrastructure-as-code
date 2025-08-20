variable "Resource_Network" { # See r-network-spoke.tf and r-network-spoke.auto.tfvars
  description = "Specialized mapping of resources."
  type        = map(any)
  nullable    = false
}

variable "Tags" {
  default     = {}
  type        = map(string)
  description = "A map of tags used for all resources created in this module."
}
/*
#flow logs related variables.
variable "enable_flow_logs" {
  description = "The boolean flag whether to enable VPC Flow Logs"
  default     = false
}

variable "flow_logs_role" {
  description = "Flow logs role name"
  default = null
}

variable "flow_logs_role_policy" {
  description = "Flow logs policy name"
  default = null
}

variable "flow_logs_destination_type" {
  description = "The type of the logging destination. Valid values: cloud-watch-logs, s3"
  default     = "cloud-watch-logs"
}

variable "flow_logs_retention_in_days" {
  description = "Number of days to retain logs if vpc_log_destination_type is cloud-watch-logs. CIS recommends 365 days. Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. Set to 0 to keep logs indefinitely."
  default     = 365
}

variable "flow_logs_iam_role" {
  default     = null
  description = "The name of the IAM Role which will be used by VPC Flow Logs if vpc_log_destination_type is cloud-watch-logs."
}

variable "flow_logs_log_group_name" {
  description = "The name of CloudWatch Logs group to which VPC Flow Logs are delivered if vpc_log_destination_type is cloud-watch-logs."
  default     = "flow-logs"
}


variable "modify_cwan_rt" {
  default = false
  type = bool
  description = "Modify cloudwan route tables or not."
}
*/