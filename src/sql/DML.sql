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


INSERT INTO Regiao (id, id_mundo, nome, descricao, tipo_região)
VALUES
-- Dungeons
    (1, 1, 'Cidadela Sem Sol', 'Uma antiga fortaleza enterrada sob o solo, lar de goblins e kobolds.', 'D'),
    (2, 1, 'Tumba dos Horrores', 'Um labirinto mortal criado por Acererak, o lich, repleto de armadilhas.', 'D'),
    (3, 2, 'Cripta da Rainha Lich', 'Uma masmorra guardada por mortos-vivos.', 'D'),
    (4, 2, 'Fortaleza Infernal de Avernus', 'Uma fortaleza no primeiro nível dos Nove Infernos.', 'D'),

-- Florestas
    (5, 1, 'Floresta de Cormanthor', 'Um vasto bosque antigo, lar de elfos e druidas.', 'F'),
    (6, 1, 'Floresta Neverwinter', 'Uma floresta mágica habitada por criaturas feéricas.', 'F'),
    (7, 2, 'Floresta Sombria', 'Um lugar onde a luz do sol raramente penetra, repleto de perigos.', 'F'),

-- Cidades
    (8, 1, 'Águas Profundas', 'A Cidade dos Esplendores, cheia de intrigas e aventuras.', 'C'),
    (9, 1, 'Baldur’s Gate', 'Uma cidade portuária movimentada, repleta de perigos e oportunidades.', 'C'),
    (10, 2, 'Neverwinter', 'Uma cidade mágica conhecida como a "Jóia do Norte".', 'C'),
    (11, 2, 'Silverymoon', 'Uma cidade élfica dedicada à magia e ao aprendizado.', 'C');


INSERT INTO Salas (id, id_regiao, nome)
VALUES
-- Salas nas Dungeons
    (1, 1, 'Entrada da Cidadela'),
    (2, 1, 'Jardim do Crepúsculo'),
    (3, 2, 'Corredor das Armadilhas'),
    (4, 2, 'Sala do Lich'),
    (5, 3, 'Salão dos Guardiões Mortos'),
    (6, 3, 'Sarcófago da Rainha Lich'),
    (7, 4, 'Sala da Batalha Infernal'),
    (8, 4, 'Trono de Bel'),

-- Salas nas Florestas
    (9, 5, 'Clareira dos Druidas'),
    (10, 5, 'Ruínas Élficas'),
    (11, 6, 'Caverna da Ninfa'),
    (12, 6, 'Fonte do Sol Eterno'),
    (13, 7, 'Passagem Sombria'),
    (14, 7, 'Templo Abandonado'),

-- Salas nas Cidades
    (15, 8, 'Porto dos Mercadores'),
    (16, 8, 'Taverna Portal Bocejante'),
    (17, 9, 'Mercado Central'),
    (18, 9, 'Fortaleza de Vigilantes'),
    (19, 10, 'Palácio de Neverember'),
    (20, 10, 'Forja dos Mestres'),
    (21, 11, 'Torre da Lua'),
    (22, 11, 'Biblioteca Mística');



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

INSERT INTO Loja (dono, tipo, nome, id_sala)
VALUES
-- Lojas em Águas Profundas
    (1, 'Amadureiro', 'O Alforge do Destino', 15), 
    (2, 'Armeiro', 'Forja do Dragão', 16);        


-- Lojas em Baldur’s Gate
    (3, 'Amadureiro', 'Mercado das Maravilhas', 17), 
    (4, 'Alquimista', 'Laboratório Místico', 18);    


-- Lojas em Neverwinter
    (5, 'Armeiro', 'Aço Glorioso', 19), 
    (6, 'Alquimista', 'Poções do Norte', 20);


-- Lojas em Silverymoon
    (7, 'Amadureiro', 'Tesouros de Silverymoon', 21), 
    (8, 'Armeiro', 'A Lâmina Reluzente', 22);



INSERT INTO Item (id, nome, tipo_item)
VALUES
    -- Armaduras
    (1, 'Armadura de Couro', 'Armadura'),
    (2, 'Armadura de Placas', 'Armadura'),
    (3, 'Armadura de Malha', 'Armadura'),

    -- Armas
    (5, 'Espada Longa', 'Arma'),
    (6, 'Arco Longo', 'Arma'),
    (7, 'Machado de Batalha', 'Arma'),
    (8, 'Cajado Mágico', 'Arma'),

    -- Consumíveis
    (9, 'Poção de Cura', 'Consumivel'),
    (10, 'Poção de Invisibilidade', 'Consumivel'),
    (11, 'Poção de Força', 'Consumivel'),
    (12, 'Elixir da Velocidade', 'Consumivel');

INSERT INTO Armadura (id_item, defesa, resistencia, descricao)
VALUES
    (1, 11, 0, 'Armadura leve feita de couro endurecido. Oferece alta mobilidade.'),
    (2, 18, 5, 'Armadura pesada composta de placas metálicas, ideal para guerreiros.'),
    (3, 16, 3, 'Armadura intermediária feita de anéis metálicos interligados.');

INSERT INTO Consumível (id_item, Benefício, descricao)
VALUES
    (9, 10, 'Restaura + 2 pontos de vida ao usuário.'),
    (10, 0, 'Torna o usuário invisível por até 1 hora ou até realizar uma ação ofensiva.'),
    (11, 5, 'Aumenta temporariamente a força do usuário para 19 por 1 hora.'),
    (12, 2, 'Dobra a velocidade de movimento e concede uma ação adicional por turno durante 1 minuto.');

INSERT INTO Arma (id_item, Dano, descricao)
VALUES
    (5, 8, 'Espada longa versátil, usada em uma ou duas mãos para combate corpo a corpo.'),
    (6, 8, 'Arco de longo alcance, ideal para ataques à distância.'),
    (7, 10, 'Machado pesado, utilizado por guerreiros para ataques devastadores.'),
    (8, 6, 'Cajado mágico usado por conjuradores para amplificar seus feitiços.');





-- UPDATES --

UPDATE Personagem SET id_sala=? WHERE id=?;

-- DELETES --
