-- --------------------------------------------------------------------------------------
-- Data Criacao ...........: 10/08/2025                                                --
-- Autor(es) ..............: Ciro Costa                                                --
-- Versao ..............: 1.0                                                          --
-- Banco de Dados .........: PostgreSQL                                                --
-- Descricao .........:  Carga de todas as tabelas do banco de dados.                  --
-- --------------------------------------------------------------------------------------
-- | Atualizacao : 10/08/2025 | Autor(es): Ciro Costa                           |      --
--                            | Descricao: Inclusão das linhas de INSERT INTO   |      --
-- --------------------------------------------------------------------------------------

-- INSERTS --

INSERT INTO Regiao (nome, descricao)
VALUES
    ('Floresta de elfos', 'Verde e cheio de arvores'),
    ('Area de Iniciante', 'Chato');

INSERT INTO Salas (id_regiao, nome)
VALUES
    (1,'Sala 1-1'),
    (1,'Sala 1-2'),
    (2,'Sala 2-3'),
    (2,'Sala 2-4');

INSERT INTO Caminhos (sala_origem, sala_destino)
VALUES
    (1,2),
    (2,1),
    (2,3),
    (3,2),
    (3,4),
    (4,3);

-- UPDATES --

UPDATE Personagem SET id_sala=? WHERE id=?;

-- DELETES --
