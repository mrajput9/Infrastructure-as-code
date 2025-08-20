

variable "vpc_id" {
  type        = string
  description = "vpc id of the vpc for which SG has to be created."
}
variable "sg_name" {
  type        = string
  description = "Name of the security group"
}

variable "sg_description" {
  type        = string
  description = "security group description"
  default     = "Security group for restricted outbound connectivity."
}

variable "sg_rules" {
  type = map(object({
    from        = number
    to          = number
    type        = string
    protocol    = string
    cidr        = list(string)
    description = string
  }))
  description = "Egress object for allowing only selected outbound connection"
  default     = {}
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}
