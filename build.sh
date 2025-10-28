#!/usr/bin/env bash
set -euo pipefail

# ====== CONFIG ======
# Configurações básicas: RM (matrícula do aluno), região Azure e nomes dos recursos
RM="${RM:-555197}"
LOCATION="${LOCATION:-brazilsouth}"
RG="rg-cp4-rm${RM}"
ACR="acrcp4rm${RM}"
IMAGE_NAME="appcp4"
TAG="${TAG:-1.0.0}"
LOGIN_SERVER="${ACR}.azurecr.io"

# ====== AZ LOGIN (se necessário) ======
# Descomente a linha abaixo se precisar fazer login no Azure CLI
# az login

# ====== CRIAR RESOURCE GROUP & ACR ======
# Cria o Resource Group no Azure (ignora se já existir)
az group create -n "$RG" -l "$LOCATION" 1> /dev/null

# Verifica se o Azure Container Registry existe, caso contrário cria um novo com SKU Basic
az acr show -n "$ACR" 1> /dev/null || az acr create -n "$ACR" -g "$RG" --sku Basic

# ====== LOGIN NO ACR ======
# Autentica o Docker local com o Azure Container Registry para push de imagens
az acr login -n "$ACR"

# ====== BUILD & PUSH LOCAL ======
# Constrói a imagem Docker da aplicação Spring Boot usando o Dockerfile
docker build -t "${LOGIN_SERVER}/${IMAGE_NAME}:${TAG}" .

# Envia a imagem construída para o Azure Container Registry
docker push "${LOGIN_SERVER}/${IMAGE_NAME}:${TAG}"

# ====== RESULTADO FINAL ======
# Exibe a URL completa da imagem publicada no ACR
echo "Imagem publicada: ${LOGIN_SERVER}/${IMAGE_NAME}:${TAG}"