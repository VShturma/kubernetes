output "master" {
  value = vcd_vapp_vm.master[*].network[0].ip
}

output "worker" {
  value = vcd_vapp_vm.worker[*].network[0].ip
}

