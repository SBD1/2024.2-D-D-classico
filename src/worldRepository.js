import client from './db-connection.js';
import { select } from '@inquirer/prompts';

export const getWorlds = async () => {
  try {
    const { rows } = await client.query('SELECT id, nome FROM Mundo ORDER BY id;');
    return rows;
  } catch (err) {
    console.error("Erro ao buscar mundos:", err);
    throw err;
  }
};


export const chooseWorld = async () => {
  const worlds = await getWorlds();
  if (!worlds || worlds.length === 0) {
    throw new Error("Nenhum mundo encontrado no banco de dados!");
  }

  const answer = await select({
    message: 'Escolha um mundo para sua aventura:',
    choices: worlds.map(w => ({
      name: w.nome,
      value: w.id
    }))
  });

  return answer; // retorna o id do mundo escolhido
};


export const getSalasByWorld = async (worldId) => {
    const query = `
      SELECT s.id, s.nome
      FROM Salas s
      JOIN Regiao r ON s.id_regiao = r.id
      WHERE r.id_mundo = $1;
    `;
    const { rows } = await client.query(query, [worldId]);
    return rows;
  };
  
  export const getRandomSalaForWorld = async (worldId) => {
    const salas = await getSalasByWorld(worldId);
    if (!salas || salas.length === 0) {
      throw new Error("Nenhuma sala encontrada para o mundo selecionado!");
    }
    const randomIndex = Math.floor(Math.random() * salas.length);
    return salas[randomIndex]; // retorna o objeto sala (pelo menos com id e nome)
  };

  // world.entity.js (ou similar)
export const getWorldByPlayerId = async (playerId) => {
    const query = `
      SELECT r.id_mundo as worldId
      FROM Personagem p
      JOIN Salas s ON p.id_sala = s.id
      JOIN Regiao r ON s.id_regiao = r.id
      WHERE p.id = $1;
    `;
    const { rows } = await client.query(query, [playerId]);
    if (rows.length === 0) {
      throw new Error("Mundo não encontrado para o jogador!");
    }
    return rows[0].worldid;
  };
  