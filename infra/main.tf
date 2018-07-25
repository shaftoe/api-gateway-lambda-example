variable "profile_name" {
  default = "default"
}

variable "region" {}

variable "domain_name" {}

variable "pushover_token" {}

variable "pushover_userkey" {}

variable "log_retention_in_days" {
  default = 7
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile_name}"
}
