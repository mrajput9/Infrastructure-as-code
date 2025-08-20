terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.55.0" # Per https://developer.hashicorp.com/terraform/language/providers/requirements, Do not use ~> (or other maximum-version constraints) for modules you intend to reuse across many configurations.
    }
  }
  required_version = ">= 1.0.0"
}
