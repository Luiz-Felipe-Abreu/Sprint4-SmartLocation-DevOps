# Smart Location - Aplicação de Geolocalização Inteligente

## 🏗️ Arquitetura da Solução

![Diagrama de Arquitetura Smart Location](image/image.png)

*Arquitetura completa com CI/CD implementada no Azure DevOps e Microsoft Azure*

### Componentes da Arquitetura:
- **GitHub Repository**: Código fonte e versionamento
- **Azure DevOps**: Orquestração de pipelines CI/CD
- **Azure Container Registry (ACR)**: Registro privado de imagens Docker
- **Azure Container Instances (ACI)**: Execução dos containers da aplicação
- **PostgreSQL em Container**: Banco de dados relacional em nuvem
- **GitHub OAuth**: Sistema de autenticação social

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
- **Deploy automatizado** com pipeline CI/CD reduzindo tempo de entrega

---

## 🛠️ Stack Tecnológica

### Backend
- **Java 17** - Linguagem principal
- **Spring Boot 3.x** - Framework web
- **Spring Security** - Autenticação e autorização
- **Spring Data JPA** - Persistência de dados
- **Thymeleaf** - Template engine server-side
- **Flyway** - Controle de versão e migração do banco

### Banco de Dados
- **PostgreSQL 17** - Banco relacional em container (Alpine Linux)
- **Azure Container Instances** - Hospedagem do banco de dados em nuvem
- **Flyway Migrations** - Versionamento automático do schema

### DevOps & Cloud
- **Docker** - Containerização da aplicação e banco de dados
- **Azure Container Registry (ACR)** - Registro privado de imagens Docker
- **Azure Container Instances (ACI)** - Execução de containers em nuvem
- **Azure DevOps Pipelines** - Orquestração CI/CD
- **Azure CLI** - Automação de infraestrutura
- **Gradle** - Build e gerenciamento de dependências
- **GitHub** - Controle de versão (SCM)
- **GitHub OAuth** - Autenticação social

### Frontend
- **Bootstrap 5** - Framework CSS responsivo
- **JavaScript ES6+** - Interatividade do cliente
- **Thymeleaf** - Renderização server-side com Spring

---

## 🔄 Fluxo CI/CD com Azure DevOps

### Pipeline de Integração Contínua (CI)

A pipeline CI é **automaticamente disparada** a cada push na branch `main` e executa os seguintes estágios:

1. **Cache de Dependências Gradle**
   - Otimiza o build reutilizando dependências já baixadas
   - Reduz tempo de execução da pipeline

2. **Build da Aplicação**
   - Compila o código Java com Gradle
   - Executa testes unitários automatizados
   - Gera relatórios JUnit de cobertura
   - Publica resultados dos testes no Azure DevOps

3. **Build da Imagem Docker**
   - Constrói imagem Docker da aplicação
   - Faz push para Azure Container Registry (ACR)
   - Tageia com `latest` e número do build
   - Utiliza Service Connection segura

4. **Publicação de Artefatos**
   - Gera arquivo JAR executável
   - Publica artefato no Azure DevOps
   - Disponibiliza para estágio de deploy

### Pipeline de Deploy Contínuo (CD)

O deploy é **automaticamente disparado** após a conclusão bem-sucedida do CI:

1. **Obtenção de Credenciais**
   - Recupera credenciais do ACR dinamicamente
   - Utiliza Azure CLI com Service Principal

2. **Limpeza de Ambiente**
   - Remove container anterior (se existir)
   - Garante estado limpo para novo deploy

3. **Provisionamento no ACI**
   - Cria novo Azure Container Instance
   - Configura variáveis de ambiente seguras
   - Injeta credenciais de banco de dados
   - Configura autenticação GitHub OAuth
   - Expõe aplicação na porta 8080

4. **Validação do Deploy**
   - Verifica status do container
   - Exibe URL de acesso da aplicação

### 🔐 Segurança e Boas Práticas

- **Variáveis Secretas**: Credenciais armazenadas como variáveis secretas no Azure DevOps
- **Service Connections**: Autenticação segura com Azure usando Service Principal
- **Container Registry Privado**: Imagens armazenadas em ACR privado
- **Restart Policy**: Containers configurados com política `Always` para alta disponibilidade
- **Separação de Ambientes**: Diferentes configurações para CI e CD


---

## 🗄️ Banco de Dados em Nuvem

### PostgreSQL em Azure Container Instance

O projeto utiliza **PostgreSQL 17 Alpine** em um container dedicado no Azure:

#### Características:
- **Tipo**: Banco de dados relacional em container
- **Provedor**: Microsoft Azure (ACI)
- **Versão**: PostgreSQL 17 com Alpine Linux
- **Alta Disponibilidade**: Restart policy configurado como `Always`
- **Recursos**: 1 CPU core e 2GB de memória RAM
- **Acesso**: FQDN público com porta 5432 exposta
- **Persistência**: Volume gerenciado pelo ACI

#### Configuração:
```yaml
Host: aci-db-smartlocation-rm555197.eastus.azurecontainer.io
Port: 5432
Database: smartlocation
Username: smartlocation
Password: [Protegido por variável secreta no Azure DevOps]
```

---


### Variáveis de Ambiente Protegidas

As seguintes variáveis são configuradas como **secretas** no Azure DevOps:

- `SPRING_DATASOURCE_URL`: URL de conexão JDBC do PostgreSQL
- `DB_PASSWORD`: Senha do banco de dados
- `GITHUB_CLIENT_ID`: Client ID da OAuth App do GitHub
- `GITHUB_CLIENT_SECRET`: Client Secret da OAuth App do GitHub
- `ACR_NAME`: Nome do Azure Container Registry
- `azureSubscription`: Service Connection com a subscription Azure

---

## 🚀 Como Executar o Projeto

### Opção 1: Via Azure DevOps (Recomendado)

1. **Faça uma alteração no código**
2. **Commit e push para branch `main`**
   ```bash
   git add .
   git commit -m "feat: nova funcionalidade"
   git push origin main
   ```
3. **Aguarde a pipeline executar automaticamente**
4. **Acesse a aplicação pela URL fornecida ao final do deploy**


#### Passos para Setup Manual

```bash
# 1. Clone o repositório
git clone https://github.com/Luiz-Felipe-Abreu/Sprint4-SmartLocation-DevOps.git
cd Sprint4-SmartLocation-DevOps

# 2. Execute o script de setup (cria ACR e banco PostgreSQL)
bash setup.sh

# 3. Configure as variáveis OAuth no Azure DevOps Library
# Vá em: Pipelines → Library → Variable Groups
# Adicione GITHUB_CLIENT_ID e GITHUB_CLIENT_SECRET

# 4. Execute a pipeline manualmente ou faça push no repositório
git push origin main

#5. Excluir grupo de recurso criado
bash delete.sh
```

### URLs de Acesso

Após o deploy bem-sucedido, acesse:

- **🌐 Aplicação Web**: `http://aci-app-smartlocation-rm555197.eastus.azurecontainer.io:8080`
- **🗄️ Banco PostgreSQL**: `aci-db-smartlocation-rm555197.eastus.azurecontainer.io:5432`

### Credenciais do Banco

```
Host: aci-db-smartlocation-rm555197.eastus.azurecontainer.io
Port: 5432
Database: smartlocation
Username: smartlocation
Password: smartlocation
```

---

## 👥 Equipe de Desenvolvimento

- **Pedro Gomes** – RM553907 - 2TDSA
- **Luiz Felipe Abreu** – RM555197 - 2TDSA
- **Matheus Munuera** – RM557812 - 2TDSA

---

## 📹 Demonstração

- **Vídeo YouTube**: https://www.youtube.com/watch?v=vGov11hSS5Q
- **Repositório GitHub**: https://github.com/Luiz-Felipe-Abreu/Sprint4-SmartLocation-DevOps.git
- **Azure DevOps**: https://dev.azure.com/RM555197/Sprint4-azure-DevOps

---

## 📄 Licença

Este projeto foi desenvolvido como parte do **Challenge DevOps - Sprint 4** - FIAP 2025.

---

## 🔍 Estrutura de Arquivos do Projeto

```
Sprint4-SmartLocation-DevOps/
├── src/                          # Código-fonte da aplicação
│   ├── main/
│   │   ├── java/                 # Classes Java
│   │   └── resources/            # Arquivos de configuração
│   │       ├── db/migration/     # Scripts Flyway
│   │       └── templates/        # Views Thymeleaf
│   └── test/                     # Testes unitários
├── azure-pipelines.yml           # Definição da pipeline CI/CD
├── Dockerfile                    # Imagem Docker da aplicação
├── setup.sh                      # Script de setup inicial do ambiente
├── delete.sh                     # Script de limpeza de recursos
├── build.gradle                  # Configuração Gradle
└── README.md                     # Documentação (este arquivo)
```

---

*Smart Location - Transformando a mobilidade urbana através da tecnologia e DevOps* 🚀
