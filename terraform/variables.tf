variable "vcd_org_network_name" {
  description = "vApp org network name"
  default = "10.77.0.1/24"
}

variable "vcd_catalog_name" {
  description = "Catalog name for VM templates"
  default = "ShturmaCatalog"
}

variable "vcd_template_name" {
  description = "Template name for VMs"
  default = "CentOS7tmpl"
}
