include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//network?ref=v0.5.0"
}

# VPC 10.0.0.0/16 com subnets privadas em 2 AZs, sem NAT.
# Interface endpoints do Bedrock Runtime e do CloudWatch Logs: cerca de US$ 29,20/mês.
# Para desligar fora da janela de teste: interface_endpoint_services = [] (a IA cai no modo mock).
inputs = {
  interface_endpoint_services = ["bedrock-runtime", "logs"]
}
