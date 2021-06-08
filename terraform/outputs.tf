output "master" {
  value = vcd_vapp_vm.master[*].network[0].ip
}
