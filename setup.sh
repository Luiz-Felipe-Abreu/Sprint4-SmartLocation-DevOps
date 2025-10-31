#!/bin/bash

# ============================================
# 🚀 SETUP SmartLocation - Ambiente Azure
# ============================================

# Variáveis principais
ACR_NAME="acrsmartlocation"
RG_NAME="rg-smartlocation"
IMAGE_NAME="appsmartlocation:latest"
LOCATION="eastus"
RM="555197"
DB_NAME="smartlocation"
DB_USER="smartlocation"
DB_PASSWORD="smartlocation"

echo "=== [1/8] Criando Resource Group ==="
az group create --name $RG_NAME --location $LOCATION

echo "=== [2/8] Criando Azure Container Registry (ACR) ==="
az acr create --resource-group $RG_NAME --name $ACR_NAME --sku Basic --location $LOCATION

echo "=== [3/8] Habilitando usuário administrador no ACR ==="
az acr update --name $ACR_NAME --admin-enabled true

# 🔐 Login no ACR
echo "=== [4/8] Fazendo login no ACR ==="
az acr login --name $ACR_NAME

# 🧱 Importar imagem base do PostgreSQL
echo "=== [5/8] Importando imagem postgres:17-alpine para o ACR ==="
docker pull postgres:17-alpine
docker tag postgres:17-alpine $ACR_NAME.azurecr.io/postgres:17-alpine
docker push $ACR_NAME.azurecr.io/postgres:17-alpine

echo "✅ Imagem postgres importada com sucesso no ACR!"

# Obter credenciais do ACR
ACR_USERNAME=$(az acr credential show -n "$ACR_NAME" --query username -o tsv)
ACR_PASSWORD=$(az acr credential show -n "$ACR_NAME" --query "passwords[0].value" -o tsv)

# 🗄️ Criar container do banco de dados PostgreSQL
DB_CONTAINER_NAME="aci-db-smartlocation-rm${RM}"
DB_DNS_LABEL="aci-db-smartlocation-rm${RM}"

echo "=== [6/8] Limpando container anterior do banco (se existir)..."
az container delete --resource-group "$RG_NAME" --name "$DB_CONTAINER_NAME" --yes 2>/dev/null || true
sleep 5

echo "=== [7/8] Criando novo container PostgreSQL ==="
az container create \
  --resource-group "$RG_NAME" \
  --name "$DB_CONTAINER_NAME" \
  --image "${ACR_NAME}.azurecr.io/postgres:17-alpine" \
  --cpu 1 --memory 2 \
  --registry-login-server "${ACR_NAME}.azurecr.io" \
  --registry-username "$ACR_USERNAME" \
  --registry-password "$ACR_PASSWORD" \
  --environment-variables \
    POSTGRES_PASSWORD="$DB_PASSWORD" \
    POSTGRES_DB="$DB_NAME" \
    POSTGRES_USER="$DB_USER" \
  --ports 5432 \
  --os-type Linux \
  --dns-name-label "$DB_DNS_LABEL" \
  --location "$LOCATION" \
  --restart-policy Always

# Obter o FQDN do container
DB_FQDN=$(az container show --resource-group "$RG_NAME" --name "$DB_CONTAINER_NAME" --query ipAddress.fqdn -o tsv)

echo ""
echo "✅ Banco de dados criado com sucesso!"
echo "------------------------------------------"
echo "🌐 JDBC URL: jdbc:postgresql://${DB_FQDN}:5432/${DB_NAME}"
echo "👤 Usuário:  ${DB_USER}"
echo "🔑 Senha:    ${DB_PASSWORD}"
echo ""
echo "------------------------------------------"
echo "Configure a variável SPRING_DATASOURCE_URL no Azure DevOps:"
echo "jdbc:postgresql://${DB_FQDN}:5432/${DB_NAME}"
echo ""
echo "✅ Setup do ambiente SmartLocation finalizado!"
