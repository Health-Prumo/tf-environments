include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//network?ref=v0.5.0"
}

# VPC 10.0.0.0/16 com subnets privadas em 2 AZs, sem NAT. A Lambda só fala com o DynamoDB
# (gateway endpoint, sem custo). Os logs da Lambda saem pelo próprio serviço, sem endpoint.
# Sem interface endpoints: o Prumo não usa IA generativa (decisão de 24/11/2026, Coach por regras).
# Se um dia o Bedrock voltar: ["bedrock-runtime"] (cerca de US$ 14,60/mês nas 2 AZs).
inputs = {
  interface_endpoint_services = []
}
