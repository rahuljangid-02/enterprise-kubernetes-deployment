#This defines the cloud provider Terraform will communicate with.

#This contains configurable values.
variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "acr_name" {
  description = "Globally unique ACR name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.acr_name))
    error_message = "ACR name must contain 5-50 letters or digits."
  }
}
