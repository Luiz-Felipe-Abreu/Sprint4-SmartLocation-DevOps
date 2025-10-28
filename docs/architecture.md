# Arquitetura (ACR + ACI)

```mermaid
flowchart LR
    dev[Dev (Pedro - RM553907)] -->|git push| gh[GitHub Repo]
    gh -->|docker build & push| acr[Azure Container Registry (acrcp4rm553907)]
    acr -->|pull image| aciApp[ACI: aci-app-cp4-rm553907]
    aciDB[ACI: aci-db-cp4-rm553907]:::db
    aciApp -->|JDBC| aciDB
    user[Usuário (navegador)] -->|HTTP 8080| aciApp

    classDef db fill:#e0f7fa,stroke:#006064;
```

**Fluxo**: Desenvolvedor envia o código → builda imagem Docker → publica no ACR → cria dois ACI: um para a aplicação (Java/Spring) e outro para o banco (PostgreSQL). A aplicação lê variáveis de ambiente para conectar no banco.
