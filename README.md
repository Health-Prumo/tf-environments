# tf-environments

Ambientes da infraestrutura do **Prumo** na AWS, em Terragrunt. Os módulos vêm do [Health-Prumo/tf-blueprint](https://github.com/Health-Prumo/tf-blueprint), sempre fixados por tag.

## Estrutura

```
global/              # recursos de escopo da conta
├── root.hcl         # estado remoto, provider e entradas comuns
├── budgets/         # alertas de custo em US$ 20 e US$ 40
└── cost-anomaly/    # anomalias de custo acima de US$ 5, resumo diário por e-mail
```

Os ambientes da aplicação (`dev/` e, se precisar, `prod/`) entram quando a infra for provisionada.

## Conta

| | |
|---|---|
| Conta | `health-prumo` (444331926746), plano Free |
| Região | `us-east-1` |
| Estado | S3 `prumo-terraform-state-444331926746`, com versionamento e trava nativa (`use_lockfile`) |

O provider tem `allowed_account_ids`, então qualquer comando em outra conta falha antes de mudar algo.

## Pré-requisitos

- Terraform >= 1.10 e Terragrunt >= 1.0
- Acesso à conta pela CLI: `aws login --profile prumo` e `export AWS_PROFILE=prumo`
- E-mails dos alertas (fora do repositório, que é público):
  - `export PRUMO_ALERT_EMAILS="a@exemplo.com,b@exemplo.com"` para o `budgets`
  - `export PRUMO_ANOMALY_EMAILS="a@exemplo.com,b@exemplo.com"` para o `cost-anomaly`

## Uso

```bash
cd global/budgets
terragrunt plan
terragrunt apply
```

Na primeira execução da conta, o bucket do estado ainda não existe. Crie com `terragrunt init --backend-bootstrap`.

Para rodar tudo de um ambiente: `terragrunt run --all plan` dentro de `global/`.
