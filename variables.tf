variable "proxmox_endpoint" {
  type    = string
  default = "https://10.0.0.2:8006/"
}
variable "proxmox_node" {
  type = string
}
variable "vm_template_id" {
  type    = number
  default = 9001
}
variable "vm_template_name" {
  type    = string
  default = "debian-cloud-image"
}
variable "vm_template_description" {
  type    = string
  default = "Debian Cloud Image managed by Terraform"
}
variable "vm_template_tags" {
  type    = list(string)
  default = ["terraform"]
}
variable "cloud_image_datastore" {
  type    = string
  default = "local"
}
variable "cloud_image_source_url" {
  type    = string
  default = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}
variable "cloud_image_source_filename" {
  type    = string
  default = "debian-12-generic-amd64.img"
}
variable "vendor_cloud_config_datastore" {
  type    = string
  default = "local"
}
variable "vm_datastore" {
  type    = string
  default = "local-lvm"
}
variable "vm_template_cloud_init_domain" {
  type = string
}
variable "vm_template_cloud_init_servers" {
  type = list(string)
}
variable "vm_template_cloud_init_username" {
  type = string
}
variable "vm_template_cloud_init_ssh_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}
