CREATE TABLE IF NOT EXISTS perfil_usuario (
  id BIGSERIAL PRIMARY KEY,
  github_username VARCHAR(255) UNIQUE,
  nome_completo VARCHAR(255),
  email VARCHAR(255),
  telefone VARCHAR(255),
  cargo VARCHAR(255)
);
