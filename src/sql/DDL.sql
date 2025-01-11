-- --------------------------------------------------------------------------------------
-- Data Criacao ...........: 10/01/2025                                                --
-- Autor(es) ..............: Ciro Costa                                                --
-- Versao ..............: 1.0                                                          --
-- Banco de Dados .........: PostgreSQL                                                --
-- Descricao .........: Inclusão de CREATE TABLE de todas as tabelas do banco de dados.--
-- --------------------------------------------------------------------------------------
-- | Atualizacao : 10/01/2025 | Autor(es): Ciro Costa                           |      --
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
    xp_base int NOT NULL DEFAULT 0,
    destreza int NOT NULL,
    carisma int NOT NULL,
    forca int NOT NULL,
    constituicao int NOT NULL,
    sabedoria int NOT NULL,
    inteligencia int NOT NULL,
     
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

CREATE TABLE IF NOT EXISTS Venda (
    id SERIAL PRIMARY KEY,
    id_loja int NOT NULL,
    id_instancia_item int NOT NULL,
    preco int NOT NULL,
    quantidade int NOT NULL
)

CREATE TABLE IF NOT EXISTS Inst_Item (
    id SERIAL PRIMARY KEY,
    id_item int NOT NULL
)

CREATE TABLE IF NOT EXISTS Missao (
    id SERIAL PRIMARY KEY,
    recompensa int NOT NULL,
    id_personagem int NOT NULL,
    titulo char(100) NOT NULL,
    objetivo char(500) NOT NULL
)

CREATE TABLE IF NOT EXISTS Item (
    id SERIAL PRIMARY KEY,
    nome char(100) NOT NULL,
    tipo_item char(1) NOT NULL
)

CREATE TABLE IF NOT EXISTS Derrota (
    id_derrota int NOT NULL,
    id_instancia_personagem int NOT NULL,
    id_personagem int NOT NULL,
    drop_item int NOT NULL,
    qtd_xp int NOT NULL
)

CREATE TABLE IF NOT EXISTS Inst_Missao (
    id SERIAL PRIMARY KEY,
    missao int NOT NULL,
    id_personagem int NOT NULL
)

CREATE TABLE IF NOT EXISTS Dialogo (
    id SERIAL PRIMARY KEY,
    missao int NOT NULL,
    conteudo varchar(500)
)

CREATE TABLE IF NOT EXISTS Armadura (
    id_item int NOT NULL PRIMARY KEY,
    defesa int NOT NULL,
    resistencia int NOT NULL,
    descricao varchar(500)
)

CREATE TABLE IF NOT EXISTS Consumível (
    id_item int NOT NULL PRIMARY KEY,
    Benefício int NOT NULL,
    descricao varchar(500)
)

CREATE TABLE IF NOT EXISTS Arma (
    id_item int NOT NULL PRIMARY KEY,
    Dano int NOT NULL,
    descricao varchar(500)
)
CREATE TABLE IF NOT EXISTS Sala_caminho (
    id_sala int NOT NULL,
    id_caminho int NOT NULL,
)

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
ALTER TABLE Venda ADD CONSTRAINT "FK_10" FOREIGN KEY (id_loja) REFERENCES Loja (id);
ALTER TABLE Venda ADD CONSTRAINT "FK_11" FOREIGN KEY (id_instancia_item) REFERENCES Inst_Item (id);
ALTER TABLE Inst_Item ADD CONSTRAINT "FK_12" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Missao ADD CONSTRAINT "FK_13" FOREIGN KEY (recompensa) REFERENCES Inst_Item (id);
ALTER TABLE Missao ADD CONSTRAINT "FK_14" FOREIGN KEY (id_personagem) REFERENCES Personagem (id);
ALTER TABLE Derrota ADD CONSTRAINT "FK_15" PRIMARY KEY (id_derrota, id_instancia_personagem, id_personagem);
ALTER TABLE Derrota ADD CONSTRAINT "FK_16" FOREIGN KEY (drop_item) REFERENCES Inst_Item (id);
ALTER TABLE Inst_Missao ADD CONSTRAINT "FK_17" FOREIGN KEY (missao) REFERENCES Missao (id);
ALTER TABLE Inst_Missao ADD CONSTRAINT "FK_18" FOREIGN KEY (id_personagem) REFERENCES Personagem (id);
ALTER TABLE Dialogo ADD CONSTRAINT "FK_19" FOREIGN KEY (missao) REFERENCES Missao (id);
ALTER TABLE Armadura ADD CONSTRAINT "FK_20" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Consumível ADD CONSTRAINT "FK_21" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Arma ADD CONSTRAINT "FK_22" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Sala_caminho ADD CONSTRAINT "FK_23" FOREIGN KEY (id_sala) REFERENCES Salas (id);
ALTER TABLE Sala_caminho ADD CONSTRAINT "FK_24" FOREIGN KEY (id_caminho) REFERENCES Caminhos (id);