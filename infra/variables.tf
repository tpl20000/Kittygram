variable "ssh_public_key" { 
  type = string 
}

variable "YC_CLOUD_ID" {
  type      = string
  sensitive = true
}

variable "YC_FOLDER_ID" {
  type      = string
  sensitive = true
}

variable "YC_IMAGE_ID" {
  type      = string
  sensitive = true
}

variable "YC_SERVICER_ID" {
  type      = string
  sensitive = true
}

variable "YC_IAM_TOKEN" {
  type      = string
  sensitive = true
}