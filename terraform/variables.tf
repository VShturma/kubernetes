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

##########################
# vCloud connection info #
##########################

variable "vcd_user" {
  description = "vCloud username"
}

variable "vcd_pass" {
  description = "vCloud password"
}

variable "vcd_org" {
  description = "vCloud Organization"
}

variable "vcd_vdc" {
  description = "vCloud Virtual Datacenter"
}

variable "vcd_url" {
  description = "vCloud URL"
}

variable "allow_unverified_ssl" {
  description = "Allow connection to self-signed VCD SSL certificates"
}
