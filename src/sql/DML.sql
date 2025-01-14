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

INSERT INTO Inst_Item (id, id_item)
VALUES
    (1, 8),
    (2, 8),
    (3, 8),
    (4, 8);

INSERT INTO Missao(id, recompensa, id_raca, titulo, objetivo, recompensa_gold)
VALUES
    (1, 1, 1, 'Dungeons e mate o dragon', 'Pelas vastas terras, ao longe, você avista um dragão, mate-o!', 500);

INSERT INTO Inst_Missao(id, id_missao, id_personagem)
VALUES  
    (1, 1, 68);

INSERT INTO Raca (id, nome, is_hostil) 
VALUES
    (1, 'Humano', false),
    (2, 'Elfo', false),
    (3, 'Anão', false),
    (4, 'Halfling', false),
    (5, 'Gnomo', false),
    (6, 'Tiefling', false),
    (7, 'Dragonborn', false),
    (8, 'Meio-Orc', false),
    (9, 'Meio-Elfo', false),
    (10, 'Orc', true),
    (11, 'Goblin', true),
    (12, 'Kobold', true),
    (13, 'Hobgoblin', true),
    (14, 'Drow', true),
    (15, 'Tritão', false),
    (16, 'Aarakocra', false),
    (17, 'Genasi', false),
    (18, 'Tabaxi', false),
    (19, 'Firbolg', false),
    (20, 'Yuan-ti Pureblood', true);

INSERT INTO Classe (id, nome, bonus, tipo) VALUES
    (1, 'Bárbaro', 3, 'B'),
    (2, 'Bardo', 2, 'B'),
    (3, 'Clérigo', 3, 'C'),
    (4, 'Druida', 2, 'D'),
    (5, 'Guerreiro', 4, 'G'),
    (6, 'Monge', 3, 'M'),
    (7, 'Paladino', 3, 'P'),
    (8, 'Patrulheiro', 3, 'P'),
    (9, 'Ladino', 2, 'L'),
    (10, 'Feiticeiro', 4, 'F'),
    (11, 'Bruxo', 4, 'B'),
    (12, 'Mago', 5, 'M');

INSERT INTO Personagem (id, id_sala, id_classe, nome, id_raca, tipo_personagem, vida, nivel, xp_base, destreza, carisma, forca, constituicao, sabedoria, inteligencia, gold) 
VALUES 

-- Inimigos
    (1, 3, 9, 'Ladrão Kobold', 12, 'I', 40, 4, 0, 14, 10, 8, 8, 10, 12, 30),
    (2, 4, 11, 'Necromante Orc', 10, 'I', 60, 7, 0, 11, 9, 11, 11, 13, 17, 70),
    (3, 5, 1, 'Bárbaro Troll', 8, 'I', 100, 8, 0, 9, 6, 18, 16, 7, 8, 120),
    (4, 6, 9, 'Assassino Drow', 14, 'I', 55, 6, 0, 15, 11, 10, 9, 12, 14, 80),
    (5, 7, 8, 'Arqueiro Goblin', 11, 'I', 45, 5, 0, 13, 9, 7, 8, 11, 13, 40),
    (6, 8, 3, 'Xamã Gnoll', 12, 'I', 65, 7, 0, 12, 8, 10, 10, 15, 16, 60),
    (7, 9, 5, 'Cavaleiro Morto-Vivo', 19, 'I', 90, 8, 0, 10, 7, 16, 14, 9, 12, 100),
    (8, 10, 7, 'Senhor Demônio', 20, 'I', 120, 10, 0, 9, 8, 20, 18, 8, 18, 150),
    (9, 11, 10, 'Mago do Fogo Infernal', 20, 'I', 70, 7, 0, 12, 14, 9, 10, 11, 18, 90),
    (10, 12, 3, 'Clérigo das Chamas Eternas', 6, 'I', 60, 6, 0, 10, 12, 8, 11, 15, 16, 80),
    (11, 13, 7, 'Paladino da Fúria Infernal', 8, 'I', 100, 8, 0, 9, 13, 15, 14, 9, 10, 120),
    (12, 14, 5, 'Guerreiro Demoníaco', 20, 'I', 85, 7, 0, 11, 10, 17, 13, 8, 9, 110),
    (13, 1, 8, 'Arqueiro das Chamas', 11, 'I', 65, 6, 0, 14, 9, 10, 10, 12, 15, 75),
    (14, 2, 4, 'Druida do Inferno Ardente', 17, 'I', 75, 7, 0, 12, 11, 9, 12, 16, 14, 85),
    (15, 3, 2, 'Bardo das Chamas Dançantes', 9, 'I', 50, 5, 0, 13, 15, 8, 9, 12, 17, 60),
    (16, 4, 1, 'Bárbaro do Fogo', 7, 'I', 110, 9, 0, 10, 8, 18, 15, 7, 8, 130),
    (17, 5, 6, 'Monge das Cinzas', 10, 'I', 55, 5, 0, 15, 10, 9, 11, 13, 16, 70),
    (18, 6, 11, 'Bruxo do Inferno', 6, 'I', 80, 8, 0, 12, 14, 11, 10, 13, 18, 100),
    (19, 7, 10, 'Mago do Gelo Eterno', 17, 'I', 65, 7, 0, 11, 13, 8, 10, 14, 18, 85),
    (20, 8, 3, 'Clérigo das Nevascas', 6, 'I', 70, 6, 0, 9, 11, 9, 12, 16, 15, 90),
    (21, 9, 7, 'Paladino da Geada', 15, 'I', 95, 8, 0, 10, 12, 14, 13, 9, 11, 115),
    (22, 10, 5, 'Guerreiro Congelante', 19, 'I', 80, 7, 0, 12, 10, 16, 12, 10, 12, 105),
    (23, 11, 8, 'Arqueiro das Neves', 11, 'I', 60, 6, 0, 14, 8, 9, 9, 13, 14, 70),
    (24, 12, 4, 'Druida do Inverno', 16, 'I', 75, 7, 0, 11, 10, 10, 13, 17, 13, 80),
    (25, 13, 2, 'Bardo da Geleira', 9, 'I', 55, 5, 0, 12, 14, 7, 10, 15, 16, 65),
    (26, 14, 1, 'Bárbaro da Tundra', 7, 'I', 105, 9, 0, 10, 7, 17, 14, 8, 9, 125),
    (27, 1, 6, 'Monge da Neve', 10, 'I', 50, 5, 0, 14, 9, 8, 10, 12, 15, 60),
    (28, 2, 11, 'Bruxo do Gelo Negro', 6, 'I', 75, 8, 0, 11, 13, 10, 11, 14, 18, 95);
    (29, 1, 8, 'Ladrão das Sombras', 12, 'I', 45, 5, 0, 14, 10, 9, 9, 11, 13, 35),
    (30, 2, 11, 'Feiticeiro do Submundo', 10, 'I', 60, 7, 0, 10, 12, 10, 11, 14, 16, 80),
    (31, 3, 9, 'Assassino Noturno', 14, 'I', 55, 6, 0, 16, 9, 11, 10, 13, 14, 75),
    (32, 4, 6, 'Monge das Trevas', 11, 'I', 50, 5, 0, 14, 8, 10, 9, 12, 15, 70),
    (33, 5, 7, 'Paladino das Profundezas', 8, 'I', 100, 8, 0, 9, 13, 15, 14, 9, 10, 120),
    (34, 6, 3, 'Clérigo dos Mortos', 6, 'I', 60, 6, 0, 9, 11, 8, 12, 16, 15, 90),
    (35, 7, 1, 'Bárbaro das Catacumbas', 7, 'I', 110, 9, 0, 10, 7, 18, 15, 7, 8, 130),
    (36, 8, 4, 'Druida da Escuridão', 17, 'I', 75, 7, 0, 11, 10, 9, 12, 16, 14, 85),
    (37, 9, 5, 'Guerreiro Subterrâneo', 19, 'I', 85, 7, 0, 12, 9, 17, 13, 8, 10, 110),
    (38, 10, 2, 'Bardo dos Sepulcros', 9, 'I', 50, 5, 0, 13, 12, 8, 9, 12, 16, 65),
    (39, 11, 10, 'Mago das Sombras', 20, 'I', 70, 7, 0, 12, 13, 9, 10, 11, 18, 90),
    (40, 12, 3, 'Clérigo das Trevas Eternas', 6, 'I', 60, 6, 0, 10, 11, 8, 11, 15, 16, 80),
    (41, 13, 8, 'Arqueiro do Crepúsculo', 11, 'I', 65, 6, 0, 14, 9, 10, 10, 12, 15, 75),
    (42, 14, 7, 'Paladino da Noite Eterna', 15, 'I', 95, 8, 0, 10, 12, 14, 13, 9, 11, 115),
    (43, 15, 5, 'Guerreiro das Trevas', 19, 'I', 80, 7, 0, 11, 9, 16, 12, 10, 12, 105);
    (44, 1, 9, 'Bardo Melódico', 9, 'I', 50, 5, 0, 12, 15, 8, 10, 14, 16, 60),
    (45, 2, 2, 'Cantor Encantador', 12, 'I', 45, 4, 0, 11, 14, 7, 9, 13, 15, 55),
    (46, 3, 3, 'Clérigo do Coral Celestial', 6, 'I', 65, 6, 0, 10, 13, 9, 11, 16, 15, 80),
    (47, 4, 1, 'Bárbaro do Ritmo Selvagem', 7, 'I', 90, 8, 0, 10, 9, 17, 14, 8, 9, 110),
    (48, 5, 4, 'Druida da Harmonia Natural', 17, 'I', 70, 7, 0, 12, 11, 9, 12, 16, 14, 85),
    (49, 6, 5, 'Guerreiro das Notas Agudas', 19, 'I', 85, 7, 0, 11, 10, 16, 13, 9, 12, 100),
    (50, 7, 8, 'Arqueiro das Melodias', 11, 'I', 55, 5, 0, 14, 12, 8, 10, 13, 14, 75),
    (51, 8, 11, 'Feiticeiro do Som', 10, 'I', 60, 7, 0, 11, 13, 10, 11, 14, 16, 80),
    (52, 9, 7, 'Paladino da Canção Sagrada', 15, 'I', 100, 8, 0, 10, 14, 15, 14, 9, 11, 120),
    (53, 10, 6, 'Monge dos Ecos Eternos', 10, 'I', 50, 5, 0, 14, 12, 9, 10, 12, 16, 70),
    (54, 11, 10, 'Mago da Sinfonia Arcana', 20, 'I', 75, 7, 0, 12, 14, 9, 10, 11, 18, 95),
    (55, 12, 2, 'Cantor dos Encantos', 9, 'I', 55, 5, 0, 13, 15, 8, 9, 12, 17, 65),
    (56, 13, 3, 'Clérigo dos Cânticos Sagrados', 6, 'I', 60, 6, 0, 10, 12, 8, 11, 15, 16, 80),
    (57, 14, 4, 'Druida dos Sons da Natureza', 16, 'I', 75, 7, 0, 11, 11, 10, 12, 17, 13, 85),
    (58, 15, 1, 'Bárbaro da Batida Tribal', 7, 'I', 95, 8, 0, 10, 8, 18, 15, 7, 9, 125);

-- Donos das lojas em Águas Profundas
    (59, 15, 5, 'Tharion, o Mestre do Couro', 3, 'P', 60, 5, 0, 10, 14, 12, 10, 12, 10, 200), -- Amadureiro
    (60, 16, 6, 'Kael, o Forjador', 4, 'P', 80, 7, 0, 11, 10, 15, 14, 12, 9, 300);          -- Armeiro

-- Donos das lojas em Baldur’s Gate
    (61, 17, 7, 'Lorien, o Viajante', 2, 'P', 50, 4, 0, 12, 13, 10, 10, 11, 14, 150),       -- Amadureiro
    (62, 18, 8, 'Arwyn, o Alquimista', 6, 'P', 55, 6, 0, 11, 12, 9, 10, 13, 15, 250);        -- Alquimista

-- Donos das lojas em Neverwinter
    (63, 19, 9, 'Darian, o Ferreiro', 5, 'P', 75, 6, 0, 10, 9, 14, 13, 10, 11, 300),        -- Armeiro
    (64, 20, 10, 'Elyra, a Mística', 11, 'P', 65, 5, 0, 12, 14, 8, 10, 12, 16, 400);        -- Alquimista

-- Donos das lojas em Silverymoon
    (65, 21, 11, 'Nerion, o Caçador de Tesouros', 8, 'P', 70, 6, 0, 13, 12, 12, 11, 12, 15, 350), -- Amadureiro
    (66, 22, 12, 'Vaylin, o Espadachim', 9, 'P', 85, 7, 0, 10, 11, 16, 14, 10, 10, 500);          -- Armeiro

-- Personagens pacíficos
    (67, 16, 2, 'Bardo Alegre', 2, 'P', 40, 4, 0, 10, 14, 8, 9, 12, 13, 200),
    (68, 18, 4, 'Druida Protetor', 4, 'P', 60, 5, 0, 11, 12, 10, 10, 15, 14, 150);

-- Dragões de Fogo
    (69, 101, 10, 'Ignarion, o Caldeirão de Fogo', 7, 'I', 500, 20, 0, 15, 18, 25, 22, 14, 16, 10000),
    (70, 102, 10, 'Pyrrhos, a Fúria Escaldante', 7, 'I', 450, 19, 0, 14, 17, 24, 21, 13, 15, 9500),

-- Dragões de Gelo
    (71, 103, 10, 'Glaciaris, o Inverno Eterno', 7, 'I', 480, 19, 0, 13, 16, 23, 20, 15, 14, 9000),
    (72, 104, 10, 'Frostfang, o Devastador Ártico', 7, 'I', 470, 18, 0, 12, 15, 22, 21, 14, 15, 8500),

-- Dragões Negros
    (73, 105, 10, 'Umbraxas, o Pesadelo Venenoso', 7, 'I', 510, 20, 0, 16, 19, 26, 23, 14, 17, 10500),
    (74, 106, 10, 'Onyxion, o Terror Sombrio', 7, 'I', 490, 19, 0, 15, 18, 25, 22, 13, 16, 10000),

-- Dragões de Ouro
    (75, 107, 10, 'Aurelion, o Guardião das Chamas', 7, 'I', 520, 21, 0, 17, 20, 27, 24, 16, 18, 11000),
    (76, 108, 10, 'Solaryn, o Luminar Dourado', 7, 'I', 500, 20, 0, 16, 19, 26, 23, 15, 17, 10500),

-- Dragões Verdes
    (77, 109, 10, 'Verdantor, o Carrasco Esmeralda', 7, 'I', 490, 19, 0, 15, 18, 25, 22, 14, 16, 9500),
    (78, 110, 10, 'Thalassor, o Guardião Verdejante', 7, 'I', 480, 18, 0, 14, 17, 24, 21, 13, 15, 9000);

-- UPDATES --

UPDATE Personagem SET id_sala=? WHERE id=?;

--Adiciona ou subtrai uma quantidade de gold do personagem
UPDATE Personagem
SET gold = gold + ?
WHERE id = ?;

-- Atualiza a vida de um personagem
UPDATE Personagem
SET vida = ?
WHERE id = ?;

-- Atualiza o preço de um item em uma loja
UPDATE Venda
SET preco = ?
WHERE id_loja = ? AND id_instancia_item = ?;

-- Atualiza a quantidade de itens de uma Venda
UPDATE Venda
SET quantidade = quantidade + ?
WHERE id_loja = ? AND id_instancia_item = ?;

--Incrementa a experiência do personagem após uma batalha ou missão concluída.
UPDATE Personagem
SET xp_base = xp_base + ?
WHERE id = ?;

-- Atualiza o nível do personagem ao atingir certa quantidade de experiência.
UPDATE Personagem
SET nivel = nivel + ?
WHERE id = ?;

--Atualiza atributos dos Personagens
UPDATE Personagem
SET destreza = destreza + ?
WHERE id = ?;

UPDATE Personagem
SET carisma = carisma + ?
WHERE id = ?;

UPDATE Personagem
SET forca = forca + ?
WHERE id = ?;

UPDATE Personagem
SET constituicao = constituicao + ?
WHERE id = ?;

UPDATE Personagem
SET sabedoria = sabedoria + ?
WHERE id = ?;

UPDATE Personagem
SET inteligencia = inteligencia + ?
WHERE id = ?;


-- DELETES --

-- Remove um personagem do jogo
DELETE FROM Personagem
WHERE id = ?;

-- Remove um item específico do inventário de um personagem
DELETE FROM Inventario
WHERE id_pc = ? AND id_instancia_item = ?;
