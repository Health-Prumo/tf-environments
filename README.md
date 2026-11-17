# tf-environments

Ambientes da infraestrutura do **Prumo** na AWS, em Terragrunt. Os módulos vêm do [Health-Prumo/tf-blueprint](https://github.com/Health-Prumo/tf-blueprint), sempre fixados por tag.

## Estrutura

```
global/              # recursos de escopo da conta
├── root.hcl         # estado remoto, provider e entradas comuns
├── budgets/         # alertas de custo em US$ 20 e US$ 40
├── cost-anomaly/    # anomalias de custo acima de US$ 5, resumo diário por e-mail
├── dns/             # zona do healthprumo.online no Route 53 (DNS delegado pela GoDaddy)
└── landing/         # landing page em https://healthprumo.online (S3, CloudFront, ACM)
```

Os ambientes da aplicação (`dev/` e, se precisar, `prod/`) entram quando a infra for provisionada.

## Conta

| | |
|---|---|
| Conta | `health-prumo` (444331926746), plano Free |
| Região | `us-east-1` |
| Estado | S3 `prumo-terraform-state-444331926746`, com versionamento e trava nativa (`use_lockfile`) |

**Proteção contra conta errada.** O backend e o provider usam sempre o perfil `prumo` (o `AWS_PROFILE` do terminal é ignorado) e têm `allowed_account_ids = ["444331926746"]`. Com outro perfil ou outra conta, o comando falha antes de ler o estado ou mudar algo.

Se uma unidade reclamar de "Backend initialization required" depois de mudança no `root.hcl`, rode `terragrunt init -reconfigure` nela uma vez.

**Tags obrigatórias.** Todo recurso leva `ze = porvux`, junto com `Projeto`, `Ambiente`, `GerenciadoPor` e `Repositorio`. No Terraform isso vem do `default_tags` do `root.hcl`, então não precisa repetir nos módulos. O que for criado pelo console ou pela CLI também tem de receber `ze = porvux` na criação.

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

## Publicar a landing page

O conteúdo vem do repositório [Health-Prumo/Prumo-landing](https://github.com/Health-Prumo/Prumo-landing) e não é gerenciado pelo Terraform:

```bash
aws s3 cp index.html s3://prumo-global-landing-444331926746/index.html --profile prumo \
  --content-type "text/html; charset=utf-8" --cache-control "public, max-age=300"
aws cloudfront create-invalidation --profile prumo --distribution-id EGQ0HWH1J2FMC --paths "/*"
```
