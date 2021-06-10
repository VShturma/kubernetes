resource "vcd_vapp" "kube" {
  name = "kube"
}

resource "vcd_vapp_org_network" "kube-public" {
  vapp_name = vcd_vapp.kube.name
  org_network_name = var.vcd_org_network_name
}

resource "vcd_vapp_vm" "master" {
  count = 2
  vapp_name = vcd_vapp.kube.name
  name = "master${count.index + 1}"
  computer_name = "master${count.index + 1}.localhost"
  catalog_name = var.vcd_catalog_name
  template_name = var.vcd_template_name
  memory = 1024
  cpus = 2

  network {
    type = "org"
    name = "10.77.0.1/24"
    ip_allocation_mode = "MANUAL"
    ip = "10.77.0.5${count.index + 1}"
    connected = true
  }

  customization {
    enabled = true
  }
}

resource "vcd_vapp_vm" "worker" {
  count = 2
  vapp_name = vcd_vapp.kube.name
  name = "worker${count.index + 1}"
  computer_name = "worker${count.index + 1}.localhost"
  catalog_name = var.vcd_catalog_name
  template_name = var.vcd_template_name
  memory = 2048
  cpus = 2

  network {
    type = "org"
    name = "10.77.0.1/24"
    ip_allocation_mode = "MANUAL"
    ip = "10.77.0.5${count.index + 2}"
    connected = true
  }

  customization {
    enabled = true
  }
}


