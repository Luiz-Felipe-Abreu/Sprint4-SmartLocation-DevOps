#!/usr/bin/env bash
set -euo pipefail

# ====== CONFIG ======
# Configurações básicas do projeto: região Azure, nomes dos recursos
RM="${RM:-555197}"
LOCATION="${LOCATION:-brazilsouth}"
RG="rg-cp4-rm${RM}"
ACR="acrcp4rm${RM}"
LOGIN_SERVER="${ACR}.azurecr.io"
IMAGE_NAME="appcp4"
TAG="${TAG:-1.0.0}"

# ====== PARAMS DB ======
# Configurações do banco PostgreSQL: nome do database, usuário, senha e DNS labels
DB_NAME="${DB_NAME:-smartlocation}"
DB_USER="${DB_USER:-smartlocation}"
DB_PASS="${DB_PASS:-smartlocation}" # Para produção, use uma senha mais forte
DB_DNS_LABEL="db-cp4-rm${RM}"
APP_DNS_LABEL="app-cp4-rm${RM}"

# ====== PARAMS OAUTH2 (OBRIGATÓRIO configurar antes do deploy!) ======
# Credenciais do GitHub OAuth para autenticação social na aplicação
GITHUB_CLIENT_ID="${GITHUB_CLIENT_ID:-}"
GITHUB_CLIENT_SECRET="${GITHUB_CLIENT_SECRET:-}"

# ====== VALIDAÇÕES ======
# Verifica se as variáveis OAuth2 foram configuradas antes de prosseguir
if [[ -z "$GITHUB_CLIENT_ID" || -z "$GITHUB_CLIENT_SECRET" ]]; then
    echo "ERRO: Variáveis OAuth2 não configuradas!"
    echo "Configure antes de executar:"
    echo "export GITHUB_CLIENT_ID='seu-client-id'"
    echo "export GITHUB_CLIENT_SECRET='seu-client-secret'"
    echo ""
    echo "IMPORTANTE: Configure também o redirect URI no GitHub:"
    echo "http://${APP_DNS_LABEL}.${LOCATION}.azurecontainer.io:8080/login/oauth2/code/github"
    exit 1
fi

echo "✅ OAuth2 configurado corretamente"
echo "Client ID: $GITHUB_CLIENT_ID"
echo "Redirect URI: http://${APP_DNS_LABEL}.${LOCATION}.azurecontainer.io:8080/login/oauth2/code/github"

# ====== PEGAR ID DO ACR PARA PULL NA ACI ======
# Obtém o ID do Azure Container Registry para permitir que ACI faça pull das imagens
ACR_ID=$(az acr show -n "$ACR" --query id -o tsv)

# ====== HABILITAR ADMIN NO ACR ======
# Habilita acesso administrativo no ACR para simplificar a autenticação do ACI
echo "Enabling admin access for ACR..."
az acr update -n "$ACR" --admin-enabled true 1> /dev/null

# ====== CRIAR CONTAINER DO BANCO (PostgreSQL) ======
# Cria uma instância PostgreSQL no Azure Container Instances para persistir dados
az container create \
  -g "$RG" -l "$LOCATION" \
  --name "aci-db-cp4-rm${RM}" \
  --image "postgres:16-alpine" \
  --os-type Linux \
  --cpu 1 --memory 1.5 \
  --dns-name-label "$DB_DNS_LABEL" \
  --ports 5432 \
  --environment-variables POSTGRES_DB="$DB_NAME" POSTGRES_USER="$DB_USER" \
  --secure-environment-variables POSTGRES_PASSWORD="$DB_PASS" \
  --restart-policy Always

# ====== ESPERAR UNS SEGUNDO ======
# Aguarda o PostgreSQL inicializar completamente antes de criar a aplicação
echo "Aguardando DB iniciar (20s)..."; sleep 20

# ====== CRIAR CONTAINER DA APP ======
# Cria a aplicação Spring Boot no ACI com todas as variáveis de ambiente necessárias
az container create \
  -g "$RG" -l "$LOCATION" \
  --name "aci-app-cp4-rm${RM}" \
  --image "${LOGIN_SERVER}/${IMAGE_NAME}:${TAG}" \
  --os-type Linux \
  --cpu 1 --memory 2 \
  --assign-identity \
  --registry-login-server "$LOGIN_SERVER" \
  --registry-username "$(az acr credential show -n "$ACR" --query username -o tsv)" \
  --registry-password "$(az acr credential show -n "$ACR" --query passwords[0].value -o tsv)" \
  --dns-name-label "$APP_DNS_LABEL" \
  --ports 8080 \
  --environment-variables \
      SPRING_PROFILES_ACTIVE=prod \
      DB_HOST="${DB_DNS_LABEL}.${LOCATION}.azurecontainer.io" \
      DB_PORT=5432 \
      DB_NAME="$DB_NAME" \
      DB_USER="$DB_USER" \
      OAUTH2_REDIRECT_URI="http://${APP_DNS_LABEL}.${LOCATION}.azurecontainer.io:8080/login/oauth2/code/github" \
  --secure-environment-variables \
      DB_PASSWORD="$DB_PASS" \
      GITHUB_CLIENT_ID="$GITHUB_CLIENT_ID" \
      GITHUB_CLIENT_SECRET="$GITHUB_CLIENT_SECRET" \
  --restart-policy Always

# ====== OBTER URLS FINAIS ======
# Recupera os FQDNs (nomes DNS completos) dos containers para exibir ao usuário
APP_FQDN=$(az container show -g "$RG" -n "aci-app-cp4-rm${RM}" --query ipAddress.fqdn -o tsv)
DB_FQDN=$(az container show -g "$RG" -n "aci-db-cp4-rm${RM}" --query ipAddress.fqdn -o tsv)

echo "App URL:    http://${APP_FQDN}:8080"
echo "DB Address: ${DB_FQDN}:5432"