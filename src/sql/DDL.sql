-- --------------------------------------------------------------------------------------
-- Data Criacao ...........: 10/01/2025                                                --
-- Autor(es) ..............: Ciro Costa                                                --
-- Versao ..............: 1.0                                                          --
-- Banco de Dados .........: PostgreSQL                                                --
-- Descricao .........: Inclusão de CREATE TABLE de todas as tabelas do banco de dados.--
-- --------------------------------------------------------------------------------------
-- | Atualizacao : 10/08/2025 | Autor(es): Ciro Costa                           |      --
--                            | Descricao: Inclusão das linhas de CREATE TABLE  |      --
-- --------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Regiao (
    id SERIAL PRIMARY KEY,
    id_mundo int NOT NULL,
    nome char(150) NOT NULL,
    descricao char(250) NOT NULL DEFAULT 'Sem Descrição',
    tipo_região char(1) NOT NULL
);

CREATE TABLE IF NOT EXISTS Salas (
    id SERIAL PRIMARY KEY,
    id_regiao int NOT NULL,
    nome char(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS Caminhos (
    sala_origem int NOT NULL,
    sala_destino int NOT NULL
);

CREATE TABLE IF NOT EXISTS Personagem (
    id SERIAL PRIMARY KEY,
    id_sala int NOT NULL,
    id_classe int NOT NULL,
    nome char(150) NOT NULL,
    tipo_personagem char(1) NOT NULL,
    vida int NOT NULL,
    nivel int NOT NULL,
    xp_base int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Mundo (
    id SERIAL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS Classe (
    id SERIAL PRIMARY KEY,
    nome char(50),
    bonus int NOT NULL,
    tipo char(1) NOT NULL
);

CREATE TABLE IF NOT EXISTS Loja (
    id SERIAL PRIMARY KEY,
    dono int NOT NULL,
    nome char(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Inventario (
    id SERIAL PRIMARY KEY,
    id_pc int NOT NULL,
    capacidade int NOT NULL
);


-- Keys

ALTER TABLE Salas ADD CONSTRAINT "FK_01" FOREIGN KEY (id_regiao) REFERENCES Regiao (id);
ALTER TABLE Personagem ADD CONSTRAINT "FK_02" FOREIGN KEY (id_sala) REFERENCES Salas (id);
ALTER TABLE Caminhos ADD CONSTRAINT "FK_03" FOREIGN KEY (sala_origem) REFERENCES Salas (id);
ALTER TABLE Caminhos ADD CONSTRAINT "FK_04" FOREIGN KEY (sala_destino) REFERENCES Salas (id);
ALTER TABLE Caminhos ADD CONSTRAINT "FK_05" PRIMARY KEY (sala_origem, sala_destino);
ALTER TABLE Regiao ADD CONSTRAINT "FK_06" PRIMARY KEY (id_mundo) REFERENCES Mundo (id);
ALTER TABLE Personagem ADD CONSTRAINT "FK_07" FOREIGN KEY (id_classe) REFERENCES Classe (id);
ALTER TABLE Loja ADD CONSTRAINT "FK_08" FOREIGN KEY (dono) REFERENCES Personagem (id);
ALTER TABLE Inventario ADD CONSTRAINT "FK_09" FOREIGN KEY (id_pc) REFERENCES Personagem (id);


