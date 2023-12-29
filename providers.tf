terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.42.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = true
  ssh {
    agent = true
  }
}
