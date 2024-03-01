# Automação da infraestrutura

Repositório do projeto [terraform-ecs-fargate](https://gitlab.com/souzafpv/terraform-ecs-fargate), executa a pipeline CI/CD para deploy da infraestrutura na AWS.


## AWS ECS Fargate
Executando aplicações em contêiner na nuvem sem a necessidade de gerenciar Instâncias EC2

## Diagrama da Infraestrutura 
<img title="Diagrama da Infraestrutura" alt="Diagrama da Infraestrutura" src="infra-ecs-fargate.png">

## Recursos provisionados

- Virtual Private Cloud (VPC)
- Balanceador de Carga de Aplicação (ALB)
- Definição de Cluster, Serviço e Tarefa do ECS
- Gerenciamento de Acesso à Identidade (IAM)
- Grupos de Segurança
- Grupo de log do CloudWatch
- Repositório de imagens ECR

## Instalação

Provisionar todos os recursos para executar a Aplicação.

## Configura o TFC para backend dos tfstates
```
    terraform {

    cloud {
        organization = "sua-organizacao-aqui"
        workspaces {
        name = "terraform-ecs"
        }
    }

```
## No Terminal

```bash
$ git clone git@gitlab.com:souzafpv/terraform-ecs-fargate.git
$ cd terraform-ecs-fargate

$ terraform init
$ terraform plan -out=terraform-ecs.plan
$ terraform apply terraform-ecs.plan
```

## Remove todos os recursos da infra provisionada na AWS
```bash
$ terraform destroy -auto-approve
```



## Aplicacao Comentarios API

Este aplicativo pode ser executado completamente usando `Docker` e `docker-compose`. O uso do Docker é recomendado, pois garante que a aplicação seja executada usando versões compatíveis de Python.


```bash
$ docker-compose up comentarios-api
```

Abra no navegador `http://localhost:8080`.

### Executando localmente

Execute os seguintes comandos para inicializar seu ambiente se você não conseguir executar o aplicativo usando Docker

```bash
$ git clone https://github.com/guilhermefpv/comentarios-api.git 
$ cd comentarios-api
$ pip install -r requirements/dev.txt
```


Os comandos de interação com a API são os seguintes:

* Start da app

```
cd app
gunicorn --log-level debug api:app
```

* Criando e listando comentários por matéria

```
# matéria 1
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"first post!","content_id":1}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"alice@example.com","comment":"ok, now I am gonna say something more useful","content_id":1}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I agree","content_id":1}'

# matéria 2
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"bob@example.com","comment":"I guess this is a good thing","content_id":2}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"charlie@example.com","comment":"Indeed, dear Bob, I believe so as well","content_id":2}'
curl -sv localhost:8000/api/comment/new -X POST -H 'Content-Type: application/json' -d '{"email":"eve@example.com","comment":"Nah, you both are wrong","content_id":2}'

# listagem matéria 1
curl -sv localhost:8000/api/comment/list/1

# listagem matéria 2
curl -sv localhost:8000/api/comment/list/2
```