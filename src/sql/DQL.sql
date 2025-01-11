-- --------------------------------------------------------------------------------------
-- Data Criacao ...........: 10/08/2025                                                --
-- Autor(es) ..............: Ciro Costa                                                --
-- Versao ..............: 1.0                                                          --
-- Banco de Dados .........: PostgreSQL                                                --
-- Descricao .........: Consulta das tabelas do banco de dados.                        --
-- --------------------------------------------------------------------------------------
-- | Atualizacao : 10/08/2025 | Autor(es): Ciro Costa                               |  --
--                            | Descricao: Inclusão das consultas do banco de dados |  --
-- --------------------------------------------------------------------------------------

-- Personagem --

-- Consultas Persongagems em uma sala
SELECT * FROM Personagem p WHERE p.id_sala = ?;

-- Salas --

-- Consulta salas disponíveis para caminhar a partir dos caminhos
SELECT * FROM Salas s 
  INNER JOIN Caminhos c on s.id = c.sala_destino
  WHERE c.sala_origem = ?;
  
-- Regiôes --

-- Consulta todas regiçoes
SELECT * FROM Regiao r;

-- Consulta regiao a partir de uma sala
SELECT * FROM Regiao r
  INNER JOIN Salas s on r.id = s.regiao
  WHERE s.id = ?;
-- listar todas as Armaduras
SELECT * FROM Armadura a
  JOIN Item i ON a.id = i.id
-- listar todas as Armas
SELECT * FROM Arma a
  JOIN Item i ON a.id = i.id
-- listar todas as Consumivel
SELECT * FROM Consumivel c 
  JOIN Item i ON c.id = i.id
-- listar todas as caminhos disponíveis
SELECT s.nome AS sala_origem, d.nome AS sala_destino 
FROM Caminhos c
JOIN Salas s ON c.sala_origem = s.id
JOIN Salas d ON c.sala_destino = d.id;

-- Buscar o inventário de um personagem
SELECT i.id, i.capacidade 
FROM Inventario i
JOIN Personagem p ON i.id_pc = p.id

-- Buscar todas as missões associadas a um personagem
SELECT m.titulo, m.objetivo 
FROM Missao m
JOIN Personagem p ON m.id_personagem = p.id

--Listar lojas com o tipo e o nome do dono
SELECT L.id, L.nome, L.tipo, P.nome AS dono
FROM Loja L
JOIN Personagem P ON L.dono = P.id;

--Obter itens à venda em uma loja específica
SELECT V.id, I.nome, V.preco, V.quantidade
FROM Venda V
JOIN Inst_Item II ON V.id_instancia_item = II.id
JOIN Item I ON II.id_item = I.id

--Listar diálogos associados a missões
SELECT conteudo
FROM Dialogo D
JOIN Missao M ON D.missao = M.id
WHERE M.id = ? and D.id = ?;

--Listar personagens na mesma sala
SELECT *
FROM Personagem
WHERE id_sala = ?

--Listar todos os personagens com seus atributos 
SELECT id, nome, tipo_personagem, vida, nivel, destreza, carisma, forca
FROM Personagem;
--Listar uma recompensa de uma missão
SELECT recompensa FROM Missao
WHERE id = ?;
