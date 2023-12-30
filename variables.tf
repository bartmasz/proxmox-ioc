variable "proxmox_endpoint" {
  type    = string
  default = "https://10.0.0.2:8006/"
}
variable "proxmox_node" {
  type = string
}
variable "proxmox_gateway" {
  type    = string
  default = "10.0.0.1"
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
# k8s custers
variable "k8s_cluster_tags" {
  type    = list(string)
  default = ["terraform", "k8s"]
}
variable "k8s_cluster_specs" {
  type = list(object({
    vm_id            = number
    type             = string
    cpu_cores        = number
    cpu_limit        = number
    cpu_units        = number
    memory_dedicated = number
    hostname         = string
    ip_address       = string
    startup = object({
      order      = number
      up_delay   = number
      down_delay = number
    })
  }))
  validation {
    condition     = alltrue([for spec in var.k8s_cluster_specs : contains(["manager", "node"], spec.type)])
    error_message = "Each k8s_cluster_specs type must be 'manager' or 'node'."
  }
}
