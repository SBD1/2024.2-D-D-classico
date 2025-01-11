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
