variable "exoscale_api_key" {
  default = "<read from env>"
  description = "The API key from Exoscale"
}

variable "exoscale_secret_key" {
  default = "<read from env>"
  description = "The Secret Key from Exoscale"
}

variable "exoscale_ssh_keypair_name" {
  default = "<read from env>"
  description = "The SSH keypair to be allowed on the instance"
}
