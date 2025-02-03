# 2024.2-D-D-Classico

## Configuração do Ambiente

### 1. Configurar Variáveis de Ambiente
Copie o arquivo `.env.example` e renomeie para `.env`.

### 2. Rodando o Banco de Dados
```bash
# Iniciar o banco de dados
docker-compose up postgres

# Rodar em background
docker-compose up postgres -d
```

### 3. Acessando o Terminal do Banco
```bash
docker exec -it 20242-d-d-classico-postgres-1 psql -U user -d test
```
Para se conectar ao banco, utilize o comando:
```bash
\c
```

### 4. Instalando Dependências
```bash
npm install
```

### 5. Iniciando o Jogo
```bash
npm start
```

### 6. Rodando a Documentação
```bash
# Iniciar a documentação
docker-compose up mkdocs

# Rodar em background
docker-compose up mkdocs -d
