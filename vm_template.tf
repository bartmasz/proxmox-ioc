resource "proxmox_virtual_environment_vm" "vm_template" {
  node_name   = var.proxmox_node
  vm_id       = var.vm_template_id
  name        = var.vm_template_name
  description = var.vm_template_description
  tags        = var.vm_template_tags

  agent {
    enabled = true
  }

  started = false

  on_boot = false

  template = true

  boot_order = ["scsi0"]

  memory {
    dedicated = 1024
  }

  cpu {
    type  = "host"
    cores = 1
  }

  scsi_hardware = "virtio-scsi-pci"

  network_device {
    bridge  = "vmbr0"
    model   = "virtio"
    enabled = true
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  disk {
    datastore_id = var.vm_datastore
    file_id      = proxmox_virtual_environment_file.cloud_image.id
    interface    = "scsi0"
  }
  initialization {
    datastore_id = var.vm_datastore
    dns {
      domain  = var.vm_template_cloud_init_domain
      servers = var.vm_template_cloud_init_servers
    }
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_template_cloud_init_username
      keys     = [file(var.vm_template_cloud_init_ssh_key_path)]
    }

    vendor_data_file_id = proxmox_virtual_environment_file.vendor_cloud_config.id
  }
  lifecycle {
    ignore_changes = [
      # List of attributes to ignore
      initialization,
    ]
  }
}

resource "proxmox_virtual_environment_file" "cloud_image" {
  content_type = "iso"
  datastore_id = var.cloud_image_datastore
  node_name    = var.proxmox_node

  source_file {
    path      = var.cloud_image_source_url
    file_name = var.cloud_image_source_filename
  }
}

resource "proxmox_virtual_environment_file" "vendor_cloud_config" {
  content_type = "snippets"
  datastore_id = var.vendor_cloud_config_datastore
  node_name    = var.proxmox_node

  source_raw {
    data = <<EOF
#cloud-config

runcmd:
  - apt update
  - apt install -y qemu-guest-agent
  - systemctl enable --now qemu-guest-agent
EOF

    file_name = "enable-qemu-guest-agent.yaml"
  }
}
