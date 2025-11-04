# Imagem base oficial do Python
FROM python:3.11-slim

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o código da aplicação
COPY app.py .

# Instala o Flask
RUN pip install flask

# Define a porta padrão que o container vai expor
EXPOSE 5000

# Comando para rodar a aplicação
CMD ["python", "app.py"]
