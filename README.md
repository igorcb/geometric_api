
# Geometric API

API para gerenciamento de quadros e círculos com validações geométricas, desenvolvida em Ruby on Rails (API-only).

## 1. Boas práticas de Rails
- Estrutura padrão Rails 7 API-only
- Controllers enxutos, validações e regras de negócio nos models
- Cobertura de testes com RSpec (request specs)
- Documentação automática com Swagger/OpenAPI via rswag
- Uso de serializers e responses JSON

## 2. Configuração Docker
- Ambiente isolado com Docker Compose
- Serviços:
  - `web`: aplicação Rails
  - `db`: banco de dados PostgreSQL
- Sem necessidade de ajuste manual de permissões ou volumes para desenvolvimento

## 3. Setup e execução

### Pré-requisitos
- Docker e Docker Compose instalados

### Passos
1. Clone o repositório:
	```sh
	git clone git@github.com:igorcb/geometric_api.git
	cd geometric_api
	```
2. Construa os containers:
	```sh
	docker compose build
	```
3. Suba o banco de dados e a aplicação:
	```sh
	docker compose up -d db
	docker compose up -d web
	```
4. Crie e migre o banco:
	```sh
	docker compose run --rm web bundle exec rails db:create db:migrate
	docker compose run --rm web bundle exec rails db:create db:migrate RAILS_ENV=test
	```
5. Rode os testes:
	```sh
	docker compose run --rm -e RAILS_ENV=test web bundle exec rspec spec/
	```
6. Acesse a aplicação:
	- API: [http://localhost:3000](http://localhost:3000)
	- Swagger: [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

## 4. Documentação Swagger
- A documentação OpenAPI está disponível em `/api-docs`.
- O arquivo `swagger/v1/swagger.yaml` descreve todos os endpoints, modelos e exemplos de request/response.
- Para atualizar a documentação, edite o arquivo YAML conforme necessário.

---

**Dúvidas ou sugestões:**
Abra uma issue ou entre em contato!
