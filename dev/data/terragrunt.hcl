include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//dynamodb-table?ref=v0.5.0"
}

# Tabela única prumo-dev-dados: PK = USUARIO#<id>, SK = PERFIL | DIA#<aaaa-mm-dd> | CHAT#<timestamp>.
inputs = {
  table_name    = "dados"
  ttl_attribute = "expira_em"
}
