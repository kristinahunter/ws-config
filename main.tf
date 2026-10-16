terraform {
  required_version = ">= 1.16.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

# 2 is compliant, 3 or more fails policies/pets.policy.hcl.
variable "pet_length" {
  type    = number
  default = 3
}

# Set to "" to trip the owner policy.
variable "owner" {
  type    = string
  default = "kristina"
}

resource "random_pet" "this" {
  length = var.pet_length
  keepers = {
    owner = var.owner
  }
}

# Changing bump re-creates the id, which is a cheap way to generate state versions
# for the restore and data-retention tests.
variable "bump" {
  type    = number
  default = 1
}

resource "random_id" "state_churn" {
  byte_length = 4
  keepers = {
    bump = var.bump
  }
}

output "pet_name" {
  value = random_pet.this.id
}

output "churn_id" {
  value = random_id.state_churn.hex
}
