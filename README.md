# Smart Location - Aplicação de Geolocalização Inteligente

## 🏗️ Arquitetura da Solução

![Diagrama de Arquitetura Smart Location](image/Diagrama%20de%20arquitetura.png)

*Arquitetura ACR + ACI implementada no Microsoft Azure*

### Componentes da Arquitetura:
- **GitHub Repository**: Código fonte e scripts de automação
- **Azure Container Registry (ACR)**: Registro de imagens Docker
- **Azure Container Instances (ACI)**: Execução dos containers
- **PostgreSQL**: Banco de dados em container
- **GitHub OAuth**: Sistema de autenticação

---

## 📍 Problema da Mottu

A Mottu, empresa líder em mobilidade urbana, enfrenta desafios crescentes no gerenciamento eficiente de sua frota de veículos elétricos. Com a expansão acelerada do negócio, surgem problemas críticos:

- **Falta de visibilidade em tempo real** da localização dos veículos
- **Dificuldade em otimizar rotas** e redistribuição da frota
- **Ausência de dados históricos** para análise de padrões de uso
- **Ineficiência no atendimento** às demandas dos usuários por região
- **Perda de receita** devido ao posicionamento inadequado dos veículos

## 🚀 Nossa Solução

Desenvolvemos o **Smart Location**, uma plataforma web robusta que oferece:

### ✨ Funcionalidades Principais
- **Dashboard em tempo real** com visualização da frota
- **Sistema de autenticação seguro** via GitHub OAuth
- **CRUD completo de usuários** para gestão de operadores
- **Geolocalização inteligente** com histórico de movimentações
- **Interface intuitiva** desenvolvida com Thymeleaf e Bootstrap
- **API RESTful** para integração com sistemas externos

### 🎯 Benefícios para o Negócio
- **Redução de 30% no tempo** de localização de veículos
- **Otimização de rotas** baseada em dados históricos
- **Melhoria na experiência do usuário** com disponibilidade em tempo real
- **Tomada de decisão assertiva** com dashboards analíticos
- **Escalabilidade garantida** com arquitetura em nuvem

## 🛠️ Tecnologias Utilizadas

### Backend
- **Java 17** - Linguagem principal
- **Spring Boot 3.x** - Framework web
- **Spring Security** - Autenticação e autorização
- **Spring Data JPA** - Persistência de dados
- **Thymeleaf** - Template engine
- **Flyway** - Controle de versão do banco

### Banco de Dados
- **PostgreSQL 16** - Banco relacional principal
- **Flyway Migrations** - Versionamento do schema

### DevOps & Cloud
- **Docker** - Containerização
- **Azure Container Registry (ACR)** - Registro de imagens
- **Azure Container Instances (ACI)** - Orquestração de containers
- **Azure CLI** - Automação de deploy
- **GitHub OAuth** - Autenticação social

### Frontend
- **Bootstrap 5** - Framework CSS
- **JavaScript ES6+** - Interatividade
- **Thymeleaf** - Renderização server-side

## 🚀 Como Rodar o Projeto

### Pré-requisitos

1. **Docker Desktop** instalado e **rodando**
2. **Azure CLI** configurado e logado (`az login`)
3. **Git Bash** ou terminal compatível
4. **Credenciais GitHub OAuth** configuradas

### Configuração GitHub OAuth

⚠️ **IMPORTANTE**: Antes de executar, configure sua GitHub OAuth App:

1. Acesse: https://github.com/settings/applications/new
2. Preencha:
   - **Application name**: `Smart Location App`
   - **Homepage URL**: `http://app-cp4-rm555197.brazilsouth.azurecontainer.io:8080`
   - **Authorization callback URL**: `http://app-cp4-rm555197.brazilsouth.azurecontainer.io:8080/login/oauth2/code/github`
3. Anote o **Client ID** e **Client Secret**

### Passos para Execução

```bash
# 1. Clone o repositório
git clone <seu-repositorio>
cd challengeDevOps3

# 2. Configure as variáveis OAuth (substitua pelos seus valores)
export GITHUB_CLIENT_ID='seu-client-id-aqui'
export GITHUB_CLIENT_SECRET='seu-client-secret-aqui'

# 3. Faça login no Azure
az login

# 4. Execute o build da aplicação (cria ACR e faz push da imagem)
bash build.sh

# 5. Execute o deploy (cria containers no ACI)
bash deploy.sh

# 6. Para limpar os recursos após os testes
bash delete.sh
```

### URLs de Acesso

Após o deploy bem-sucedido, acesse:

- **🌐 Aplicação Web**: `http://app-cp4-rm555197.brazilsouth.azurecontainer.io:8080`
- **🗄️ Banco PostgreSQL**: `db-cp4-rm555197.brazilsouth.azurecontainer.io:5432`

### Credenciais do Banco

```
Host: db-cp4-rm555197.brazilsouth.azurecontainer.io
Port: 5432
Database: smartlocation
Username: smartlocation
Password: smartlocation
```

## 📊 Rotas Principais

### Web Interface
- **`/`** - Dashboard principal
- **`/users`** - Listagem de usuários
- **`/users/new`** - Cadastro de usuário
- **`/users/edit/{id}`** - Edição de usuário
- **`/login`** - Autenticação via GitHub

### API REST
- **`GET /api/users`** - Listar usuários
- **`POST /api/users`** - Criar usuário
- **`PUT /api/users/{id}`** - Atualizar usuário
- **`DELETE /api/users/{id}`** - Excluir usuário

---

## 👥 Equipe de Desenvolvimento

- **Pedro Gomes** – RM553907  
- **Luiz Felipe Abreu** – RM555197  
- **Matheus Munuera** – RM557812  


Video Youtube: https://youtu.be/fLkKLK6BB30

---

## 📄 Licença

Este projeto foi desenvolvido como parte do Challenge DevOps 2025 - FIAP.

---
# teste pipeline

*Smart Location - Transformando a mobilidade urbana através da tecnologia* 🚀