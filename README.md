# Cidade Ágil

Plataforma de denúncias de manutenção urbana. O objetivo é conectar cidadãos e gestores públicos em torno de problemas de infraestrutura urbana — buracos, iluminação, calçadas, saneamento — com acompanhamento em tempo real do status de cada ocorrência.

O sistema é composto por três partes: um app mobile para os cidadãos registrarem e acompanharem ocorrências, um painel web para gestores e técnicos gerenciarem a fila de atendimento, e uma API REST que conecta tudo.

<!-- screenshot do app mobile aqui -->

<!-- screenshot do painel web aqui -->

## Tecnologias

**Back-end:** Java 17, Spring Boot 3, PostgreSQL + PostGIS

**Mobile:** Flutter 3

**Web:** Angular 20

**Infraestrutura:** Docker + Docker Compose para banco de dados local

## Pré-requisitos

- Java 17+
- Maven (ou use o wrapper `./mvnw` incluído)
- Flutter 3.x
- Node.js 20+ e npm
- Docker e Docker Compose
- Arquivo `.env` na raiz do projeto (veja `.env.example`)

## Como rodar localmente

**1. Configure as variáveis de ambiente**

Copie o arquivo de exemplo e preencha os valores:

```bash
cp .env.example .env
```

**2. Suba o banco de dados**

```bash
docker compose up -d db
```

**3. Inicie o back-end**

As migrations do Flyway rodam automaticamente na primeira inicialização.

```bash
cd backend
./mvnw spring-boot:run
```

Para aplicar migrations manualmente sem subir o servidor (útil em desenvolvimento):

```bash
cd backend
./mvnw initialize flyway:migrate
```

O `initialize` é necessário para que o Maven carregue as variáveis do `.env` antes de executar o plugin do Flyway.

A API estará disponível em `http://localhost:8080`. A documentação interativa (Swagger) pode ser acessada em `http://localhost:8080/swagger-ui.html`.

**4. Rode o app mobile**

```bash
cd mobile
flutter pub get
flutter run
```

**5. Rode o painel web**

```bash
cd web
npm install
npm run dev
```

O painel estará disponível em `http://localhost:4200`.
## Estrutura do repositório

```
cidade-agil/
  backend/    API REST em Spring Boot
  mobile/     App Flutter para cidadãos
  web/        Painel Angular para gestores
  docs/       Documentação técnica do projeto
```
