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

-- Inferno
    (66, 1, 'Inferno', 'Somente para os mortos.', 'D');

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



-- Inserções principais: Conexões internas e as interconexões básicas entre grupos
INSERT INTO Caminhos (sala_origem, sala_destino)
VALUES
  -- Conexões internas das Dungeons (salas 1 a 8)
  (1, 2), (2, 1),
  (2, 3), (3, 2),
  (3, 4), (4, 3),
  (4, 5), (5, 4),
  (5, 6), (6, 5),
  (6, 7), (7, 6),
  (7, 8), (8, 7),

  -- Conexões internas das Florestas (salas 9 a 14)
  (9, 10), (10, 9),
  (10, 11), (11, 10),
  (11, 12), (12, 11),
  (12, 13), (13, 12),
  (13, 14), (14, 13),

  -- Conexões internas das Cidades (salas 15 a 22)
  (15, 16), (16, 15),
  (16, 17), (17, 16),
  (17, 18), (18, 17),
  (18, 19), (19, 18),
  (19, 20), (20, 19),
  (20, 21), (21, 20),
  (21, 22), (22, 21),

  -- Conexões básicas entre os grupos:
  (8, 9), (9, 8),         -- Liga a última sala das Dungeons (8) com a primeira da Floresta (9)
  (14, 15), (15, 14),      -- Liga a última sala das Florestas (14) com a primeira da Cidade (15)
  (4, 17), (17, 4);        -- Conexão extra entre uma Dungeon (4) e uma Cidade (17)

-- Inserções adicionais para que cada Dungeon tenha pelo menos uma conexão com uma Floresta e uma Cidade:
INSERT INTO Caminhos (sala_origem, sala_destino)
VALUES
  -- Para Dungeon sala 1:
  (1, 10), (10, 1),       -- Conexão com a Floresta (sala 10)
  (1, 15), (15, 1),       -- Conexão com a Cidade (sala 15)

  -- Para Dungeon sala 2:
  (2, 11), (11, 2),       -- Conexão com a Floresta (sala 11)
  (2, 16), (16, 2),       -- Conexão com a Cidade (sala 16)

  -- Para Dungeon sala 3:
  (3, 12), (12, 3),       -- Conexão com a Floresta (sala 12)
  (3, 18), (18, 3),       -- Conexão com a Cidade (sala 18)

  -- Para Dungeon sala 4:
  (4, 13), (13, 4),       -- Conexão com a Floresta (sala 13)
  -- (4, 17), (17, 4) já existem

  -- Para Dungeon sala 5:
  (5, 14), (14, 5),       -- Conexão com a Floresta (sala 14)
  (5, 19), (19, 5),       -- Conexão com a Cidade (sala 19)

  -- Para Dungeon sala 6:
  (6, 9), (9, 6),         -- Conexão com a Floresta (sala 9)
  (6, 20), (20, 6),       -- Conexão com a Cidade (sala 20)

  -- Para Dungeon sala 7:
  (7, 11), (11, 7),       -- Conexão com a Floresta (sala 11) – mesmo que já exista, reforça a ligação
  (7, 21), (21, 7),       -- Conexão com a Cidade (sala 21)

  -- Para Dungeon sala 8:
  -- (8, 9) já existe (conexão com Floresta)
  (8, 22), (22, 8);       -- Conexão com a Cidade (sala 22)

-- Inserções adicionais para que cada Floresta tenha pelo menos uma conexão com uma Cidade:
INSERT INTO Caminhos (sala_origem, sala_destino)
VALUES
  (9, 15), (15, 9),       -- Para a Floresta sala 9 conectar com Cidade (sala 15)
  (10, 16), (16, 10),     -- Para a Floresta sala 10 conectar com Cidade (sala 16)
  (11, 17), (17, 11),     -- Para a Floresta sala 11 conectar com Cidade (sala 17)
  (12, 18), (18, 12),     -- Para a Floresta sala 12 conectar com Cidade (sala 18)
  (13, 19), (19, 13);     -- Para a Floresta sala 13 conectar com Cidade (sala 19)
-- (A Floresta sala 14 já está conectada à Cidade pelas conexões (14,15) e (15,14))


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

INSERT INTO Personagem (id_sala, id_classe, nome, id_raca, tipo_personagem, vida, nivel, xp_base, destreza, carisma, forca, constituicao, sabedoria, inteligencia, gold) 
VALUES 

-- Inimigos
    (3, 9, 'Ladrão Kobold', 12, 'Inimigo', 40, 4, 0, 14, 10, 8, 8, 10, 12, 30),
    (4, 11, 'Necromante Orc', 10, 'Inimigo', 60, 7, 0, 11, 9, 11, 11, 13, 17, 70),
    (5, 1, 'Bárbaro Troll', 8, 'Inimigo', 100, 8, 0, 9, 6, 18, 16, 7, 8, 120),
    (6, 9, 'Assassino Drow', 14, 'Inimigo', 55, 6, 0, 15, 11, 10, 9, 12, 14, 80),
    (7, 8, 'Arqueiro Goblin', 11, 'Inimigo', 45, 5, 0, 13, 9, 7, 8, 11, 13, 40),
    (8, 3, 'Xamã Gnoll', 12, 'Inimigo', 65, 7, 0, 12, 8, 10, 10, 15, 16, 60),
    (9, 5, 'Cavaleiro Morto-Vivo', 19, 'Inimigo', 90, 8, 0, 10, 7, 16, 14, 9, 12, 100),
    (10, 7, 'Senhor Demônio', 20, 'Inimigo', 120, 10, 0, 9, 8, 20, 18, 8, 18, 150),
    (11, 10, 'Mago do Fogo Infernal', 20, 'Inimigo', 70, 7, 0, 12, 14, 9, 10, 11, 18, 90),
    (12, 3, 'Clérigo das Chamas Eternas', 6, 'Inimigo', 60, 6, 0, 10, 12, 8, 11, 15, 16, 80),
    (13, 7, 'Paladino da Fúria Infernal', 8, 'Inimigo', 100, 8, 0, 9, 13, 15, 14, 9, 10, 120),
    (14, 5, 'Guerreiro Demoníaco', 20, 'Inimigo', 85, 7, 0, 11, 10, 17, 13, 8, 9, 110),
    (1, 8, 'Arqueiro das Chamas', 11, 'Inimigo', 65, 6, 0, 14, 9, 10, 10, 12, 15, 75),
    (2, 4, 'Druida do Inferno Ardente', 17, 'Inimigo', 75, 7, 0, 12, 11, 9, 12, 16, 14, 85),
    (3, 2, 'Bardo das Chamas Dançantes', 9, 'Inimigo', 50, 5, 0, 13, 15, 8, 9, 12, 17, 60),
    (4, 1, 'Bárbaro do Fogo', 7, 'Inimigo', 110, 9, 0, 10, 8, 18, 15, 7, 8, 130),
    (5, 6, 'Monge das Cinzas', 10, 'Inimigo', 55, 5, 0, 15, 10, 9, 11, 13, 16, 70),
    (6, 11, 'Bruxo do Inferno', 6, 'Inimigo', 80, 8, 0, 12, 14, 11, 10, 13, 18, 100),
    (7, 10, 'Mago do Gelo Eterno', 17, 'Inimigo', 65, 7, 0, 11, 13, 8, 10, 14, 18, 85),
    (8, 3, 'Clérigo das Nevascas', 6, 'Inimigo', 70, 6, 0, 9, 11, 9, 12, 16, 15, 90),
    (9, 7, 'Paladino da Geada', 15, 'Inimigo', 95, 8, 0, 10, 12, 14, 13, 9, 11, 115),
    (10, 5, 'Guerreiro Congelante', 19, 'Inimigo', 80, 7, 0, 12, 10, 16, 12, 10, 12, 105),
    (11, 8, 'Arqueiro das Neves', 11, 'Inimigo', 60, 6, 0, 14, 8, 9, 9, 13, 14, 70),
    (12, 4, 'Druida do Inverno', 16, 'Inimigo', 75, 7, 0, 11, 10, 10, 13, 17, 13, 80),
    (13, 2, 'Bardo da Geleira', 9, 'Inimigo', 55, 5, 0, 12, 14, 7, 10, 15, 16, 65),
    (14, 1, 'Bárbaro da Tundra', 7, 'Inimigo', 105, 9, 0, 10, 7, 17, 14, 8, 9, 125),
    (1, 6, 'Monge da Neve', 10, 'Inimigo', 50, 5, 0, 14, 9, 8, 10, 12, 15, 60),
    (2, 11, 'Bruxo do Gelo Negro', 6, 'Inimigo', 75, 8, 0, 11, 13, 10, 11, 14, 18, 95);
    (1, 8, 'Ladrão das Sombras', 12, 'Inimigo', 45, 5, 0, 14, 10, 9, 9, 11, 13, 35),
    (2, 11, 'Feiticeiro do Submundo', 10, 'Inimigo', 60, 7, 0, 10, 12, 10, 11, 14, 16, 80),
    (3, 9, 'Assassino Noturno', 14, 'Inimigo', 55, 6, 0, 16, 9, 11, 10, 13, 14, 75),
    (4, 6, 'Monge das Trevas', 11, 'Inimigo', 50, 5, 0, 14, 8, 10, 9, 12, 15, 70),
    (5, 7, 'Paladino das Profundezas', 8, 'Inimigo', 100, 8, 0, 9, 13, 15, 14, 9, 10, 120),
    (6, 3, 'Clérigo dos Mortos', 6, 'Inimigo', 60, 6, 0, 9, 11, 8, 12, 16, 15, 90),
    (7, 1, 'Bárbaro das Catacumbas', 7, 'Inimigo', 110, 9, 0, 10, 7, 18, 15, 7, 8, 130),
    (8, 4, 'Druida da Escuridão', 17, 'Inimigo', 75, 7, 0, 11, 10, 9, 12, 16, 14, 85),
    (9, 5, 'Guerreiro Subterrâneo', 19, 'Inimigo', 85, 7, 0, 12, 9, 17, 13, 8, 10, 110),
    (10, 2, 'Bardo dos Sepulcros', 9, 'Inimigo', 50, 5, 0, 13, 12, 8, 9, 12, 16, 65),
    (11, 10, 'Mago das Sombras', 20, 'Inimigo', 70, 7, 0, 12, 13, 9, 10, 11, 18, 90),
    (12, 3, 'Clérigo das Trevas Eternas', 6, 'Inimigo', 60, 6, 0, 10, 11, 8, 11, 15, 16, 80),
    (13, 8, 'Arqueiro do Crepúsculo', 11, 'Inimigo', 65, 6, 0, 14, 9, 10, 10, 12, 15, 75),
    (14, 7, 'Paladino da Noite Eterna', 15, 'Inimigo', 95, 8, 0, 10, 12, 14, 13, 9, 11, 115),
    (15, 5, 'Guerreiro das Trevas', 19, 'Inimigo', 80, 7, 0, 11, 9, 16, 12, 10, 12, 105);
    (1, 9, 'Bardo Melódico', 9, 'Inimigo', 50, 5, 0, 12, 15, 8, 10, 14, 16, 60),
    (2, 2, 'Cantor Encantador', 12, 'Inimigo', 45, 4, 0, 11, 14, 7, 9, 13, 15, 55),
    (3, 3, 'Clérigo do Coral Celestial', 6, 'Inimigo', 65, 6, 0, 10, 13, 9, 11, 16, 15, 80),
    (4, 1, 'Bárbaro do Ritmo Selvagem', 7, 'Inimigo', 90, 8, 0, 10, 9, 17, 14, 8, 9, 110),
    (5, 4, 'Druida da Harmonia Natural', 17, 'Inimigo', 70, 7, 0, 12, 11, 9, 12, 16, 14, 85),
    (6, 5, 'Guerreiro das Notas Agudas', 19, 'Inimigo', 85, 7, 0, 11, 10, 16, 13, 9, 12, 100),
    (7, 8, 'Arqueiro das Melodias', 11, 'Inimigo', 55, 5, 0, 14, 12, 8, 10, 13, 14, 75),
    (8, 11, 'Feiticeiro do Som', 10, 'Inimigo', 60, 7, 0, 11, 13, 10, 11, 14, 16, 80),
    (9, 7, 'Paladino da Canção Sagrada', 15, 'Inimigo', 100, 8, 0, 10, 14, 15, 14, 9, 11, 120),
    (10, 6, 'Monge dos Ecos Eternos', 10, 'Inimigo', 50, 5, 0, 14, 12, 9, 10, 12, 16, 70),
    (11, 10, 'Mago da Sinfonia Arcana', 20, 'Inimigo', 75, 7, 0, 12, 14, 9, 10, 11, 18, 95),
    (12, 2, 'Cantor dos Encantos', 9, 'Inimigo', 55, 5, 0, 13, 15, 8, 9, 12, 17, 65),
    (13, 3, 'Clérigo dos Cânticos Sagrados', 6, 'Inimigo', 60, 6, 0, 10, 12, 8, 11, 15, 16, 80),
    (14, 4, 'Druida dos Sons da Natureza', 16, 'Inimigo', 75, 7, 0, 11, 11, 10, 12, 17, 13, 85),
    (15, 1, 'Bárbaro da Batida Tribal', 7, 'Inimigo', 95, 8, 0, 10, 8, 18, 15, 7, 9, 125);

-- Donos das lojas em Águas Profundas
    ( 15, 5, 'Tharion, o Mestre do Couro', 3, 'Pacífico', 60, 5, 0, 10, 14, 12, 10, 12, 10, 200), -- Amadureiro
    ( 16, 6, 'Kael, o Forjador', 4, 'Pacífico', 80, 7, 0, 11, 10, 15, 14, 12, 9, 300);          -- Armeiro

-- Donos das lojas em Baldur’s Gate
    ( 17, 7, 'Lorien, o Viajante', 2, 'Pacífico', 50, 4, 0, 12, 13, 10, 10, 11, 14, 150),       -- Amadureiro
    ( 18, 8, 'Arwyn, o Alquimista', 6, 'Pacífico', 55, 6, 0, 11, 12, 9, 10, 13, 15, 250);        -- Alquimista

-- Donos das lojas em Neverwinter
    (19, 9, 'Darian, o Ferreiro', 5, 'Pacífico', 75, 6, 0, 10, 9, 14, 13, 10, 11, 300),        -- Armeiro
    (20, 10, 'Elyra, a Mística', 11, 'Pacífico', 65, 5, 0, 12, 14, 8, 10, 12, 16, 400);        -- Alquimista

-- Donos das lojas em Silverymoon
    ( 21, 11, 'Nerion, o Caçador de Tesouros', 8, 'Pacífico', 70, 6, 0, 13, 12, 12, 11, 12, 15, 350), -- Amadureiro
    ( 22, 12, 'Vaylin, o Espadachim', 9, 'Pacífico', 85, 7, 0, 10, 11, 16, 14, 10, 10, 500);          -- Armeiro

-- Personagens pacíficos
    ( 16, 2, 'Bardo Alegre', 2, 'Pacífico', 40, 4, 0, 10, 14, 8, 9, 12, 13, 200),
    ( 18, 4, 'Druida Protetor', 4, 'Pacífico', 60, 5, 0, 11, 12, 10, 10, 15, 14, 150);

-- Dragões de Fogo
    ( 101, 10, 'Ignarion, o Caldeirão de Fogo', 7, 'Inimigo', 500, 20, 0, 15, 18, 25, 22, 14, 16, 10000),
    ( 102, 10, 'Pyrrhos, a Fúria Escaldante', 7, 'Inimigo', 450, 19, 0, 14, 17, 24, 21, 13, 15, 9500),

-- Dragões de Gelo
    (103, 10, 'Glaciaris, o Inverno Eterno', 7, 'Inimigo', 480, 19, 0, 13, 16, 23, 20, 15, 14, 9000),
    (104, 10, 'Frostfang, o Devastador Ártico', 7, 'Inimigo', 470, 18, 0, 12, 15, 22, 21, 14, 15, 8500),

-- Dragões Negros
    (105, 10, 'Umbraxas, o Pesadelo Venenoso', 7, 'Inimigo', 510, 20, 0, 16, 19, 26, 23, 14, 17, 10500),
    (106, 10, 'Onyxion, o Terror Sombrio', 7, 'Inimigo', 490, 19, 0, 15, 18, 25, 22, 13, 16, 10000),

-- Dragões de Ouro
    (107, 10, 'Aurelion, o Guardião das Chamas', 7, 'Inimigo', 520, 21, 0, 17, 20, 27, 24, 16, 18, 11000),
    (108, 10, 'Solaryn, o Luminar Dourado', 7, 'Inimigo', 500, 20, 0, 16, 19, 26, 23, 15, 17, 10500),

-- Dragões Verdes
    (109, 10, 'Verdantor, o Carrasco Esmeralda', 7, 'Inimigo', 490, 19, 0, 15, 18, 25, 22, 14, 16, 9500),
    (110, 10, 'Thalassor, o Guardião Verdejante', 7, 'Inimigo', 480, 18, 0, 14, 17, 24, 21, 13, 15, 9000);

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
    (10, 'Elixir Revigorante', 'Consumivel'),
    (11, 'Néctar dos Deuses', 'Consumivel');

INSERT INTO Armadura (id_item, defesa, resistencia, descricao)
VALUES
    (1, 11, 0, 'Armadura leve feita de couro endurecido. Oferece alta mobilidade.'),
    (2, 18, 5, 'Armadura pesada composta de placas metálicas, ideal para guerreiros.'),
    (3, 16, 3, 'Armadura intermediária feita de anéis metálicos interligados.');

INSERT INTO Consumível (id_item, Benefício, descricao)
VALUES
    (9, 80, 'Restaura 80 pontos de vida'),
    (10, 60, 'Restaura 60 pontos de vida'),
    (11, 40, 'Restaura 40 pontos de vida');

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

INSERT INTO Inst_Missao(id, missao, id_personagem)
VALUES  
    (1, 1, 1);

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
