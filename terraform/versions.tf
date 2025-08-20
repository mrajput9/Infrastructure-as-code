terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.41.0" # The maximum version for the 'aws' provider.
    }
  }
  required_version = ">= 1.1.0" # The minimum Terraform version required.
}