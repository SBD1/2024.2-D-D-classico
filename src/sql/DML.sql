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

INSERT INTO Mundo (id, nome)
VALUES 
    (1, 'Faerûn'),
    (2, 'Exandria');


INSERT INTO Regiao (id_mundo, nome, descricao, tipo_região)
VALUES
-- Dungeons
    (1, 'Cidadela Sem Sol', 'Uma antiga fortaleza enterrada sob o solo, lar de goblins e kobolds.', 'D'),
    (1, 'Tumba dos Horrores', 'Um labirinto mortal criado por Acererak, o lich, repleto de armadilhas.', 'D'),
    (2, 'Cripta da Rainha Lich', 'Uma masmorra guardada por mortos-vivos.', 'D'),
    (2, 'Fortaleza Infernal de Avernus', 'Uma fortaleza no primeiro nível dos Nove Infernos.', 'D'),

-- Florestas
    (1, 'Floresta de Cormanthor', 'Um vasto bosque antigo, lar de elfos e druidas.', 'F'),
    (1, 'Floresta Neverwinter', 'Uma floresta mágica habitada por criaturas feéricas.', 'F'),
    (2, 'Floresta Sombria', 'Um lugar onde a luz do sol raramente penetra, repleto de perigos.', 'F'),

-- Cidades
    (1, 'Águas Profundas', 'A Cidade dos Esplendores, cheia de intrigas e aventuras.', 'C'),
    (1, 'Baldur’s Gate', 'Uma cidade portuária movimentada, repleta de perigos e oportunidades.', 'C'),
    (2, 'Neverwinter', 'Uma cidade mágica conhecida como a "Jóia do Norte".', 'C'),
    (2, 'Silverymoon', 'Uma cidade élfica dedicada à magia e ao aprendizado.', 'C');

INSERT INTO Salas (id_regiao, nome)
VALUES
-- Salas nas Dungeons
    (1, 'Entrada da Cidadela'),
    (1, 'Jardim do Crepúsculo'),
    (2, 'Corredor das Armadilhas'),
    (2, 'Sala do Lich'),
    (3, 'Salão dos Guardiões Mortos'),
    (3, 'Sarcófago da Rainha Lich'),
    (4, 'Sala da Batalha Infernal'),
    (4, 'Trono de Bel'),

-- Salas nas Florestas
    (5, 'Clareira dos Druidas'),
    (5, 'Ruínas Élficas'),
    (6, 'Caverna da Ninfa'),
    (6, 'Fonte do Sol Eterno'),
    (7, 'Passagem Sombria'),
    (7, 'Templo Abandonado'),

-- Salas nas Cidades
    (8, 'Porto dos Mercadores'),
    (8, 'Taverna Portal Bocejante'),
    (9, 'Mercado Central'),
    (9, 'Fortaleza de Vigilantes'),
    (10, 'Palácio de Neverember'),
    (10, 'Forja dos Mestres'),
    (11, 'Torre da Lua'),
    (11, 'Biblioteca Mística');



INSERT INTO Caminhos (sala_origem, sala_destino)
VALUES
-- Caminhos entre salas das Dungeons
    (1, 2), -- Entrada da Cidadela -> Jardim do Crepúsculo
    (3, 4), -- Corredor das Armadilhas -> Sala do Lich
    (5, 6), -- Salão dos Guardiões Mortos -> Sarcófago da Rainha Lich
    (7, 8), -- Sala da Batalha Infernal -> Trono de Bel

-- Caminhos entre salas das Florestas
    (9, 10), -- Clareira dos Druidas -> Ruínas Élficas
    (11, 12), -- Caverna da Ninfa -> Fonte do Sol Eterno
    (13, 14), -- Passagem Sombria -> Templo Abandonado

-- Caminhos entre salas das Cidades
    (15, 16), -- Porto dos Mercadores -> Taverna Portal Bocejante
    (17, 18), -- Mercado Central -> Fortaleza de Vigilantes
    (19, 20), -- Palácio de Neverember -> Forja dos Mestres
    (21, 22); -- Torre da Lua -> Biblioteca Mística



-- UPDATES --

UPDATE Personagem SET id_sala=? WHERE id=?;

-- DELETES --
