resource "proxmox_virtual_environment_vm" "k8s-vm" {
  count     = length(var.k8s_cluster_specs)
  node_name = var.proxmox_node
  vm_id     = var.k8s_cluster_specs[count.index].vm_id
  name      = var.k8s_cluster_specs[count.index].hostname
  tags      = concat(var.k8s_cluster_tags, [var.k8s_cluster_specs[count.index].type])

  started = true
  on_boot = true
  startup {
    order      = var.k8s_cluster_specs[count.index].startup.order
    up_delay   = var.k8s_cluster_specs[count.index].startup.up_delay
    down_delay = var.k8s_cluster_specs[count.index].startup.down_delay
  }

  clone {
    vm_id   = var.vm_template_id
    retries = 3
  }

  boot_order = ["scsi0"]

  memory {
    dedicated = var.k8s_cluster_specs[count.index].memory_dedicated
  }

  cpu {
    type  = "host"
    cores = var.k8s_cluster_specs[count.index].cpu_cores
    limit = var.k8s_cluster_specs[count.index].cpu_limit
    units = var.k8s_cluster_specs[count.index].cpu_units
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.k8s_cluster_specs[count.index].ip_address
        gateway = var.proxmox_gateway
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # List of attributes to ignore
      initialization,
    ]
  }
}

resource "null_resource" "ansible_hosts" {
  depends_on = [proxmox_virtual_environment_vm.k8s-vm]

  provisioner "local-exec" {
    command = "echo '${templatefile(
      "${path.module}/templates/ansible_inventory.tpl",
      {
        user     = "${var.vm_template_cloud_init_username}"
        managers = "${local.manager_details}"
        nodes    = "${local.node_details}"
      }
    )}' > hosts.ini"
  }
}
