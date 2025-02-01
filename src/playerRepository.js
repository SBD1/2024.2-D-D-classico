import client from './db-connection.js';

export const insertPlayerToDB = async (playerData) => {
    const query = `
    INSERT INTO PERSONAGEM (
      id_sala, id_classe, nome, id_raca, tipo_personagem,
      vida, nivel, xp_base, destreza, carisma, forca,
      constituicao, sabedoria, inteligencia, gold
    ) VALUES (
      $1, $2, $3, $4, $5, 
      $6, $7, $8, $9, $10, $11, 
      $12, $13, $14, $15
    ) RETURNING *;
  `;

    const values = [
        playerData.id_sala, playerData.id_classe, playerData.nome, playerData.id_raca,
        playerData.tipo_personagem, playerData.vida, playerData.nivel, playerData.xp_base,
        playerData.destreza, playerData.carisma, playerData.forca, playerData.constituicao,
        playerData.sabedoria, playerData.inteligencia, playerData.gold
    ];

    try {
        const res = await client.query(query, values);
        return res.rows[0];
    } catch (err) {
        console.error('Erro ao inserir jogador:', err);
        throw err;
    }
};

export const getRacas = async () => {
    try {
        const res = await client.query('SELECT id, nome FROM Raca ORDER BY id;');
        return res.rows;
    } catch (err) {
        console.error('Erro ao buscar raças:', err);
        return [];
    }
};

export const getClasses = async () => {
    try {
        const res = await client.query('SELECT id, nome FROM Classe ORDER BY id;');
        return res.rows;
    } catch (err) {
        console.error('Erro ao buscar classes:', err);
        return [];
    }
};

export const getPlayerGold = async (playerId) => {
    const result = await client.query("SELECT gold FROM Personagem WHERE id = $1", [playerId]);
    return result.rows[0].gold;
  };
  
  export const updatePlayerGold = async (playerId, newGold) => {
    try {
        return client.query("UPDATE Personagem SET gold = $1 WHERE id = $2", [newGold, playerId]);
    } catch (error) {
        console.error('Erro ao atualizar ouro do jogador:', error);
        return;
    }
    
  };
  
  export const addItemToInventory = async (playerId, itemId, quantidade) => {
    try {// Adiciona um novo item ao inventário
            return client.query(`
              INSERT INTO Inventario (id_pc, id_instancia_item, capacidade) 
              VALUES ($1, $2, $3)
            `, [playerId, itemId, quantidade]);
    } catch (error) {
        console.error('Erro ao adicionar item ao inventário:', error);
        return;
    }
  };