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
-- | Atualizacao : 11/01/2025 | Autor(es): Ciro Costa                           |      --
--                            | Descricao: Ajustes no sql para executar no init |      --
-- --------------------------------------------------------------------------------------

CREATE TYPE tipo_personagem_enum AS ENUM('PC', 'Inimigo', 'Pacífico');
CREATE TYPE tipo_loja_enum AS ENUM('Amadureiro', 'Armeiro', 'Alquimista');
CREATE TYPE tipo_item_enum AS ENUM('Armadura', 'Arma', 'Consumivel');

CREATE TABLE IF NOT EXISTS Regiao (
    id SERIAL PRIMARY KEY,
    id_mundo int NOT NULL,
    nome char(150) NOT NULL,
    descricao char(250) NOT NULL DEFAULT 'Sem Descrição',
    tipo_regiao char(1) NOT NULL
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
    id_raca int NOT NULL,
    tipo_personagem tipo_personagem_enum NOT NULL,
    vida int NOT NULL,
    nivel int NOT NULL,
    xp_base int NOT NULL DEFAULT 0,
    destreza int NOT NULL,
    carisma int NOT NULL,
    forca int NOT NULL,
    constituicao int NOT NULL,
    sabedoria int NOT NULL,
    inteligencia int NOT NULL,
    gold int NOT NULL
);

CREATE TABLE IF NOT EXISTS Mundo (
    id SERIAL PRIMARY KEY,
    nome char(50)
);

CREATE TABLE IF NOT EXISTS Classe (
    id SERIAL PRIMARY KEY,
    nome char(50),
    bonus int NOT NULL,
    tipo char(1) NOT NULL
);

CREATE TABLE IF NOT EXISTS Loja (
    id SERIAL PRIMARY KEY,
    id_sala int NOT NULL,
    dono int NOT NULL,
    tipo tipo_loja_enum NOT NULL,
    nome char(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Inventario (
    id SERIAL PRIMARY KEY,
    id_pc int NOT NULL,
    id_instancia_item int
);

CREATE TABLE IF NOT EXISTS Venda (
    id SERIAL PRIMARY KEY,
    id_loja int NOT NULL,
    id_item int NOT NULL,
    preco int NOT NULL,
    quantidade int NOT NULL
);

CREATE TABLE IF NOT EXISTS Inst_Item (
    id SERIAL PRIMARY KEY,
    id_item int NOT NULL
);

CREATE TABLE IF NOT EXISTS Regristo_batalha (
    id SERIAL PRIMARY KEY,
    id_PC int NOT NULL,
    id_Inimigo int NOT NULL,
    id_sala int NOT NULL,
    data_batalha TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS Raca (
    id SERIAL PRIMARY KEY,
    nome varchar(100) NOT NULL,
    is_hostil bool NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS Missao (
    id SERIAL PRIMARY KEY,
    recompensa int NOT NULL,
    id_raca int NOT NULL,
    titulo char(100) NOT NULL,
    objetivo char(500) NOT NULL,
    recompensa_gold int NOT NULL
);

CREATE TABLE IF NOT EXISTS Item (
    id SERIAL PRIMARY KEY,
    nome char(100) NOT NULL,
    tipo_item tipo_item_enum NOT NULL
);

CREATE TABLE IF NOT EXISTS Loot (
    id SERIAL PRIMARY KEY,
    id_personagem int NOT NULL,
    drop_item int NOT NULL,
    qtd_xp int NOT NULL,
    recompensa_gold int NOT NULL
);

CREATE TABLE IF NOT EXISTS Inst_Missao (
    id SERIAL PRIMARY KEY,
    missao int NOT NULL,
    id_personagem int NOT NULL
);

CREATE TABLE IF NOT EXISTS Dialogo (
    id SERIAL PRIMARY KEY,
    missao int NOT NULL,
    conteudo varchar(500)
);

CREATE TABLE IF NOT EXISTS Armadura (
    id_item int NOT NULL PRIMARY KEY,
    defesa int NOT NULL,
    resistencia int NOT NULL,
    descricao varchar(500)
);

CREATE TABLE IF NOT EXISTS Consumível (
    id_item int NOT NULL PRIMARY KEY,
    Benefício int NOT NULL,
    descricao varchar(500)
);

CREATE TABLE IF NOT EXISTS Arma (
    id_item int NOT NULL PRIMARY KEY,
    Dano int NOT NULL,
    descricao varchar(500)
);



-- Criando a PROCEDURE para definir atributos com base na classe
CREATE OR REPLACE PROCEDURE DefinirAtributosPorClasse(
    IN p_id_classe INT,
    OUT p_xp_base INT,
    OUT p_destreza INT,
    OUT p_carisma INT,
    OUT p_forca INT,
    OUT p_constituicao INT,
    OUT p_sabedoria INT,
    OUT p_inteligencia INT
) 
AS $DefinirAtributosPorClasse$
BEGIN
    -- Definir valores padrão
    p_xp_base := 0;

    -- Selecionar atributos conforme a classe
    CASE p_id_classe
        WHEN 1 THEN -- Bárbaro
            p_destreza := 15; p_carisma := 8; p_forca := 18; p_constituicao := 16; p_sabedoria := 10; p_inteligencia := 8;
        WHEN 2 THEN -- Bardo
            p_destreza := 14; p_carisma := 16; p_forca := 10; p_constituicao := 12; p_sabedoria := 12; p_inteligencia := 14;
        WHEN 3 THEN -- Clérigo
            p_destreza := 10; p_carisma := 12; p_forca := 12; p_constituicao := 14; p_sabedoria := 18; p_inteligencia := 14;
        WHEN 4 THEN -- Druida
            p_destreza := 12; p_carisma := 10; p_forca := 14; p_constituicao := 15; p_sabedoria := 16; p_inteligencia := 13;
        WHEN 5 THEN -- Guerreiro
            p_destreza := 14; p_carisma := 10; p_forca := 18; p_constituicao := 16; p_sabedoria := 10; p_inteligencia := 12;
        WHEN 6 THEN -- Monge
            p_destreza := 16; p_carisma := 10; p_forca := 14; p_constituicao := 15; p_sabedoria := 14; p_inteligencia := 12;
        WHEN 7 THEN -- Paladino
            p_destreza := 12; p_carisma := 16; p_forca := 14; p_constituicao := 16; p_sabedoria := 12; p_inteligencia := 10;
        WHEN 8 THEN -- Patrulheiro
            p_destreza := 16; p_carisma := 10; p_forca := 14; p_constituicao := 14; p_sabedoria := 12; p_inteligencia := 12;
        WHEN 9 THEN -- Ladino
            p_destreza := 18; p_carisma := 12; p_forca := 10; p_constituicao := 14; p_sabedoria := 10; p_inteligencia := 14;
        WHEN 10 THEN -- Feiticeiro
            p_destreza := 10; p_carisma := 12; p_forca := 8; p_constituicao := 12; p_sabedoria := 12; p_inteligencia := 18;
        WHEN 11 THEN -- Bruxo
            p_destreza := 12; p_carisma := 14; p_forca := 10; p_constituicao := 12; p_sabedoria := 12; p_inteligencia := 16;
        WHEN 12 THEN -- Mago
            p_destreza := 10; p_carisma := 12; p_forca := 8; p_constituicao := 10; p_sabedoria := 14; p_inteligencia := 18;
        ELSE 
            p_destreza := 10; p_carisma := 10; p_forca := 10; p_constituicao := 10; p_sabedoria := 10; p_inteligencia := 10;
    END CASE;
END;
$DefinirAtributosPorClasse$ LANGUAGE plpgsql;

-- Criando o TRIGGER FUNCTION para chamar a procedure antes da inserção
CREATE OR REPLACE FUNCTION before_insert_personagem()
RETURNS TRIGGER AS $before_insert_personagem$
DECLARE
    v_xp_base INT;
    v_destreza INT;
    v_carisma INT;
    v_forca INT;
    v_constituicao INT;
    v_sabedoria INT;
    v_inteligencia INT;
BEGIN
    -- Chama a procedure para definir os atributos
    CALL DefinirAtributosPorClasse(
        NEW.id_classe,
        v_xp_base,
        v_destreza,
        v_carisma,
        v_forca,
        v_constituicao,
        v_sabedoria,
        v_inteligencia
    );

    -- Atualiza os atributos do novo personagem
    NEW.xp_base := v_xp_base;
    NEW.destreza := v_destreza;
    NEW.carisma := v_carisma;
    NEW.forca := v_forca;
    NEW.constituicao := v_constituicao;
    NEW.sabedoria := v_sabedoria;
    NEW.inteligencia := v_inteligencia;

    RETURN NEW;
END;
$before_insert_personagem$ LANGUAGE plpgsql;

-- Criando o TRIGGER para acionar a função antes da inserção
CREATE OR REPLACE TRIGGER before_insert_personagem_trigger
BEFORE INSERT ON Personagem
FOR EACH ROW
EXECUTE FUNCTION before_insert_personagem();

CREATE OR REPLACE FUNCTION inserir_item_no_inventario()
RETURNS TRIGGER AS $$
DECLARE
    v_qtd_itens INT;
BEGIN
    -- Verifica a quantidade de itens no inventário do personagem
    SELECT COUNT(*) INTO v_qtd_itens
    FROM inventario
    WHERE id_pc = NEW.id_pc;

    -- Se já houver 20 itens, exibe a mensagem de erro e impede a inserção
    IF v_qtd_itens >= 20 THEN
        RAISE EXCEPTION 'Seu inventário já está cheio';
    ELSE
        -- Se o limite não for atingido, permite a inserção
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE TRIGGER trigger_inserir_item_no_inventario
    BEFORE INSERT ON inventario
    FOR EACH ROW
    EXECUTE FUNCTION inserir_item_no_inventario();


ALTER TABLE Personagem
ADD CONSTRAINT unique_nome UNIQUE (nome);


-- TRIGGER: GARANTINDO GENERALIZAÇÃO/ESPECIALIZAÇÃO DE Item
CREATE OR REPLACE FUNCTION check_specialized_item()
RETURNS TRIGGER AS $$
DECLARE
    item_tipo tipo_item_enum;
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.id_item != NEW.id_item THEN
        RAISE EXCEPTION 'Não é permitido alterar o id_item na tabela %.', TG_TABLE_NAME;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Item WHERE id = NEW.id_item) THEN
        RAISE EXCEPTION 'Item % não existe na tabela Item.', NEW.id_item;
    END IF;

    SELECT tipo_item INTO item_tipo FROM Item WHERE id = NEW.id_item;

    CASE TG_TABLE_NAME
        WHEN 'armadura' THEN
            IF item_tipo != 'Armadura' THEN
                RAISE EXCEPTION 'Item % não é do tipo Armadura (tipo atual: %).', NEW.id_item, item_tipo;
            END IF;
        WHEN 'consumível' THEN
            IF item_tipo != 'Consumível' THEN
                RAISE EXCEPTION 'Item % não é do tipo Consumível (tipo atual: %).', NEW.id_item, item_tipo;
            END IF;
        WHEN 'arma' THEN
            IF item_tipo != 'Arma' THEN
                RAISE EXCEPTION 'Item % não é do tipo Arma (tipo atual: %).', NEW.id_item, item_tipo;
            END IF;
        ELSE
            RAISE EXCEPTION 'Tabela desconhecida: %', TG_TABLE_NAME;
    END CASE;

    IF EXISTS (
        SELECT 1 
        FROM (
            SELECT id_item FROM Armadura WHERE id_item = NEW.id_item
            UNION ALL
            SELECT id_item FROM Consumível WHERE id_item = NEW.id_item
            UNION ALL
            SELECT id_item FROM Arma WHERE id_item = NEW.id_item
        ) AS specialized
        WHERE id_item = NEW.id_item
        AND (TG_OP = 'INSERT' OR TG_TABLE_NAME != TG_RELNAME)
        LIMIT 1
    ) THEN
        RAISE EXCEPTION 'Item % já está em outra tabela especializada.', NEW.id_item;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_armadura_check_before
BEFORE INSERT OR UPDATE ON Armadura
FOR EACH ROW
EXECUTE FUNCTION check_specialized_item();

CREATE TRIGGER trg_consumivel_check_before
BEFORE INSERT OR UPDATE ON Consumível
FOR EACH ROW
EXECUTE FUNCTION check_specialized_item();

CREATE TRIGGER trg_arma_check_before
BEFORE INSERT OR UPDATE ON Arma
FOR EACH ROW
EXECUTE FUNCTION check_specialized_item();

-- TRIGGER: GARANTIR ITEM EM TABELA CERTO
CREATE OR REPLACE FUNCTION check_item_total_specialization()
RETURNS TRIGGER AS $$
DECLARE
    expected_table TEXT;
    actual_table TEXT;
BEGIN
    SELECT 
        CASE 
            WHEN EXISTS (SELECT 1 FROM Armadura WHERE id_item = NEW.id) THEN 'Armadura'
            WHEN EXISTS (SELECT 1 FROM Consumível WHERE id_item = NEW.id) THEN 'Consumível'
            WHEN EXISTS (SELECT 1 FROM Arma WHERE id_item = NEW.id) THEN 'Arma'
            ELSE NULL
        END INTO actual_table;

    IF actual_table IS NULL THEN
        RAISE EXCEPTION 'Item % não está em nenhuma tabela especializada.', NEW.id;
    END IF;

    IF NEW.tipo_item::TEXT != actual_table THEN
        RAISE EXCEPTION 'Tipo do item % (%) não corresponde à tabela especializada (%).', 
            NEW.id, NEW.tipo_item, actual_table;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE CONSTRAINT TRIGGER trg_item_check_total_specialization
AFTER INSERT OR UPDATE ON Item
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION check_item_total_specialization();


-- TRIGGER PARA EVITAR UPDATE NO TIPO DO ITEM CASO ELE ESTEJA EM UMA TABELA ESPECIFICA
CREATE OR REPLACE FUNCTION prevent_invalid_type_change()
RETURNS TRIGGER AS $$
DECLARE
    actual_table TEXT;
BEGIN
    IF NEW.tipo_item != OLD.tipo_item THEN
        SELECT 
            CASE 
                WHEN EXISTS (SELECT 1 FROM Armadura WHERE id_item = OLD.id) THEN 'Armadura'
                WHEN EXISTS (SELECT 1 FROM Consumível WHERE id_item = OLD.id) THEN 'Consumível'
                WHEN EXISTS (SELECT 1 FROM Arma WHERE id_item = OLD.id) THEN 'Arma'
                ELSE NULL
            END INTO actual_table;

        IF actual_table IS NOT NULL AND actual_table != NEW.tipo_item::TEXT THEN
            RAISE EXCEPTION 'Alteração do tipo_item para % inválida. Remova o item da tabela % antes.', 
                NEW.tipo_item, actual_table;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_item_prevent_invalid_type_change
BEFORE UPDATE ON Item
FOR EACH ROW
EXECUTE FUNCTION prevent_invalid_type_change();


-- TRIGGER: SOMENTE INIMIGOS NA TABELA Loot
CREATE OR REPLACE FUNCTION loot_somente_para_inimigos()
RETURNS TRIGGER AS $$
DECLARE
    tipo_personagem tipo_personagem_enum;
BEGIN
    SELECT tipo_personagem INTO tipo_personagem
    FROM Personagem
    WHERE id = NEW.id_personagem;

    IF tipo_personagem != 'Inimigo' THEN
        RAISE EXCEPTION 'Apenas personagens do tipo "Inimigo" podem ter loot';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_loot_somente_para_inimigos
BEFORE INSERT ON Loot
FOR EACH ROW
EXECUTE FUNCTION loot_somente_para_inimigos();


-- TRIGGER: GARANTINDO GENERALIZAÇÃO/ESPECIALIZAÇÃO DE Regiao
CREATE OR REPLACE FUNCTION regiao_valida_tipo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_regiao NOT IN ('C', 'F', 'D') THEN
        RAISE EXCEPTION 'Tipo de região inválido. Deve ser "C" (Cidade), "F" (Floresta) ou "D" (Dungeon)';
    END IF;

    IF NEW.tipo_regiao = 'C' THEN
        IF NEW.descricao IS NULL THEN
            RAISE EXCEPTION 'Cidades devem ter uma descrição preenchida.';
        END IF;
    ELSIF NEW.tipo_regiao = 'F' THEN
        IF NEW.descricao IS NULL THEN
            RAISE EXCEPTION 'Florestas devem ter uma descrição preenchida.';
        END IF;
    ELSIF NEW.tipo_regiao = 'D' THEN
        IF NEW.descricao IS NULL THEN
            RAISE EXCEPTION 'Dungeons devem ter uma descrição preenchida.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_regiao_valida_tipo
BEFORE INSERT OR UPDATE ON Regiao
FOR EACH ROW
EXECUTE FUNCTION regiao_valida_tipo();


-- TRIGGER: SEM Inimigos EM CIDADES
CREATE OR REPLACE FUNCTION personagem_valida_regiao()
RETURNS TRIGGER AS $$
DECLARE
    tipo_regiao CHAR(1);
BEGIN
    SELECT r.tipo_regiao INTO tipo_regiao
    FROM Regiao r
    INNER JOIN Salas s on s.id_regiao = r.id
    WHERE s.id = NEW.id_sala;

    IF NEW.tipo_personagem = 'Inimigo' AND tipo_regiao = 'C' THEN
        RAISE EXCEPTION 'Personagens do tipo "Inimigo" não podem ser inseridos em regiões do tipo "Cidade"';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_personagem_valida_regiao
BEFORE INSERT OR UPDATE ON Personagem
FOR EACH ROW
EXECUTE FUNCTION personagem_valida_regiao();


-- TRIGGER: LEVA O Inimigo PARA O INFERNO
CREATE OR REPLACE FUNCTION mover_personagem_sala_e_recuperar()
RETURNS TRIGGER AS $$
DECLARE
    sala_aleatoria INTEGER;
    nova_vida INTEGER;
BEGIN
    IF NEW.vida = 0 THEN
        PERFORM set_config('sala_66_context', 'true', true);

        UPDATE Personagem SET id_regiao = 66 WHERE id = NEW.id;

        PERFORM pg_sleep(900);

        nova_vida := FLOOR(RANDOM() * (100 - 50 + 1)) + 50;

        SELECT id INTO sala_aleatoria
        FROM Regiao
        WHERE tipo_regiao IN ('D', 'F')
        ORDER BY RANDOM() LIMIT 1;

        UPDATE Personagem
        SET vida = nova_vida, id_regiao = sala_aleatoria
        WHERE id = NEW.id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_mover_personagem_sala_e_recuperar
BEFORE UPDATE ON Personagem
FOR EACH ROW
WHEN (OLD.vida > 0 AND NEW.vida = 0) -- Quando a vida mudar para 0
EXECUTE FUNCTION mover_personagem_sala_e_recuperar();


-- TRIGGER: O INFERNO É PARA OS MORTOS
CREATE OR REPLACE FUNCTION bloquear_movimento_para_sala_66()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_regiao = 66 THEN
        IF current_setting('sala_66_context', true) IS NULL THEN
            RAISE EXCEPTION 'Movimento direto para a sala de id 66 não é permitido.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bloquear_movimento_para_sala_66
BEFORE INSERT OR UPDATE ON Personagem
FOR EACH ROW
WHEN (NEW.id_sala = 66) 
EXECUTE FUNCTION bloquear_movimento_para_sala_66();

CREATE OR REPLACE FUNCTION remover_pc_morto() 
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tipo_personagem = 'PC' AND NEW.vida <= 0 THEN
        DELETE FROM Personagem WHERE id = NEW.id;
    END IF;
    RETURN NULL; -- Retorna NULL porque o DELETE já removeu a linha
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_remover_pc_morto
AFTER UPDATE OF vida ON Personagem
FOR EACH ROW
WHEN (NEW.vida <= 0 AND NEW.tipo_personagem = 'PC')
EXECUTE FUNCTION remover_pc_morto();


-- Keys

ALTER TABLE Salas ADD CONSTRAINT "FK_01" FOREIGN KEY (id_regiao) REFERENCES Regiao (id);
ALTER TABLE Personagem ADD CONSTRAINT "FK_02" FOREIGN KEY (id_sala) REFERENCES Salas (id);
ALTER TABLE Caminhos ADD CONSTRAINT "FK_03" FOREIGN KEY (sala_origem) REFERENCES Salas (id);
ALTER TABLE Caminhos ADD CONSTRAINT "FK_04" FOREIGN KEY (sala_destino) REFERENCES Salas (id);
ALTER TABLE Caminhos ADD CONSTRAINT "FK_05" PRIMARY KEY (sala_origem, sala_destino);
ALTER TABLE Regiao ADD CONSTRAINT "FK_06" FOREIGN KEY (id_mundo) REFERENCES Mundo (id);
ALTER TABLE Personagem ADD CONSTRAINT "FK_07" FOREIGN KEY (id_classe) REFERENCES Classe (id);
ALTER TABLE Loja ADD CONSTRAINT "FK_08" FOREIGN KEY (dono) REFERENCES Personagem (id);
ALTER TABLE Inventario ADD CONSTRAINT "FK_09" FOREIGN KEY (id_pc) REFERENCES Personagem (id);
ALTER TABLE Venda ADD CONSTRAINT "FK_10" FOREIGN KEY (id_loja) REFERENCES Loja (id);
ALTER TABLE Venda ADD CONSTRAINT "FK_11" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Inst_Item ADD CONSTRAINT "FK_12" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Missao ADD CONSTRAINT "FK_13" FOREIGN KEY (recompensa) REFERENCES Inst_Item (id);
ALTER TABLE Missao ADD CONSTRAINT "FK_14" FOREIGN KEY (id_raca) REFERENCES Raca (id);
ALTER TABLE Loot ADD CONSTRAINT "FK_16" FOREIGN KEY (drop_item) REFERENCES Inst_Item (id);
ALTER TABLE Inst_Missao ADD CONSTRAINT "FK_17" FOREIGN KEY (missao) REFERENCES Missao (id);
ALTER TABLE Inst_Missao ADD CONSTRAINT "FK_18" FOREIGN KEY (id_personagem) REFERENCES Personagem (id);
ALTER TABLE Dialogo ADD CONSTRAINT "FK_19" FOREIGN KEY (missao) REFERENCES Missao (id);
ALTER TABLE Armadura ADD CONSTRAINT "FK_20" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Consumível ADD CONSTRAINT "FK_21" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Arma ADD CONSTRAINT "FK_22" FOREIGN KEY (id_item) REFERENCES Item (id);
ALTER TABLE Inventario ADD CONSTRAINT "FK_23" FOREIGN KEY (id_instancia_item) REFERENCES Item (id);
ALTER TABLE Personagem ADD CONSTRAINT "FK_24" FOREIGN KEY (id_raca) REFERENCES Raca (id);
ALTER TABLE Loot ADD CONSTRAINT "FK_25" FOREIGN KEY (id_personagem) REFERENCES Personagem(id);
ALTER TABLE Regristo_batalha ADD CONSTRAINT "FK_26" FOREIGN KEY (id_PC) REFERENCES Personagem (id);
ALTER TABLE Regristo_batalha ADD CONSTRAINT "FK_27" FOREIGN KEY (id_Inimigo) REFERENCES Personagem (id);
ALTER TABLE Regristo_batalha ADD CONSTRAINT "FK_28" FOREIGN KEY (id_sala) REFERENCES Salas (id);
ALTER TABLE Loja ADD CONSTRAINT "FK_29" FOREIGN KEY (id_sala) REFERENCES Salas (id);

