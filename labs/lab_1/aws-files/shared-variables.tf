variable "environment" {
  description = "The name of the environment in which the resources will be created'"
  default     = "aws-lab"
}
variable "flarevm_ami" {
  description = "The Amazon Machine Image (AMI) ID of the created FlareVM."
}

variable "guacamole_ami" {
  description = "The AMI for the Guacamole host"
}

variable "remnux_ami" {
  description = "The AMI for the REMnux host"
}

variable "account" {
  description = "The AWS account used for provisioning"
}

variable "region" {
  description = "The AWS region to use for the resources"
  default     = "us-east-1"
}

variable "enable_guacamole" {
  description = "Whether to enable the Guacamole server for remote access to the instances (if enabled the FlareVM will have not Internet)"
  default     = true
}