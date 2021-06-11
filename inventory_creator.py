import json

with open("./terraform/terraform_outputs.json") as terraform_output:
	output = json.load(terraform_output)

for key, value in output.items():
	with open("./ansible/inventory", "a") as inventory:
		inventory.write(f"[{key}]\n")
		for i in range(len(value['value'])):
			inventory.write(f"{key}{i+1} ansible_host={value['value'][i]}\n")
