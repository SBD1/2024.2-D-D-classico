import client from './db-connection.js';
import { executeQuery } from './db-connection.js';

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
        return res.rows[0]; // Retorna o personagem criado
    } catch (err) {
        if (err.code === '23505') { // Verifica se o erro é de violação de chave única
            console.error('Já existe um personagem com este nome, escolha um novo!');
            throw new Error('Nome de personagem já existente.'); // Lança erro específico
        } else {
            console.error('Erro ao inserir jogador:', err);
            throw err; // Rethrow se o erro for diferente
        }
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
  
  export const addItemToInventory = async (playerId, itemId) => {
    try {// Adiciona um novo item ao inventário
            return client.query(`
              INSERT INTO Inventario (id_pc, id_instancia_item) 
              VALUES ($1, $2)
            `, [playerId, itemId]);
    } catch (error) {
        console.error('Erro ao adicionar item ao inventário:', error);
        return;
    }
  };

export const getPlayerStatus = async (playerId) => {
    try {
        const { rows } = await client.query(
            `SELECT nome, vida, nivel, xp_base, destreza, carisma, forca, 
                    constituicao, sabedoria, inteligencia, gold 
             FROM Personagem 
             WHERE id = $1`,
            [playerId]
        );

        if (rows.length === 0) {
            console.log("Personagem não encontrado.");
            return null;
        }

        return rows[0];
    } catch (error) {
        console.error("Erro ao buscar status do personagem:", error);
        return null;
    }
};

export const getPlayerByName = async (playerName) => {
    try {
        const { rows } = await client.query(
            `SELECT id, nome, vida, nivel, xp_base, destreza, carisma, forca, 
                    constituicao, sabedoria, inteligencia, gold 
             FROM Personagem 
             WHERE nome = $1`,
            [playerName]
        );

        if (rows.length === 0) {
            console.log("Personagem não encontrado.");
            return null;
        }

        return rows[0];
    } catch (error) {
        console.error("Erro ao buscar personagem por nome:", error);
        return null;
    }
};

export const getEntitiesInRoom = async (roomId) => {
    const query = `
      SELECT 
        id, 
        nome,
        tipo_personagem,
        nivel,
        forca,
        vida,
        xp_base,
        gold
      FROM Personagem 
      WHERE id_sala = $1 
        AND tipo_personagem IN ('Inimigo', 'Pacífico')
        AND vida > 0;
    `;


    return await executeQuery(query, [roomId]);
};

// playerRepository.js
export const getPlayerInventory = async (playerId) => {
    try {
        const res = await client.query(
            `SELECT it.nome AS nome, COUNT(inv.id_instancia_item) AS quantidade
             FROM inventario inv
             JOIN item it ON inv.id_instancia_item = it.id
             WHERE inv.id_pc = $1
             GROUP BY it.nome`,
            [playerId]
        );

        if (res.rows.length === 0) {
            console.log("Inventário Vazio");
            return null;
        }

        return res.rows;
    } catch (error) {
        console.error("Erro ao buscar inventário do personagem:", error);
        return null;
    }
};




export const getPlayerInventoryCount = async (playerId) => {
    try {
        const res = await client.query(
            `SELECT COUNT(*) AS count
             FROM inventario 
             WHERE id_pc = $1`,
            [playerId]
        );

        // A quantidade de itens é retornada em res.rows[0].count
        return res.rows[0].count;
    } catch (error) {
        console.error("Erro ao contar inventário do personagem:", error);
        return null;
    }
};

export const salvarPersonagem = async (personagem) => {
    try {
        await executeQuery(
            `UPDATE Personagem
         SET nivel = $1, 
             vida = $2, 
             xp_base = $3, 
             gold = $4 
         WHERE id = $5`,
            [personagem.nivel, personagem.vida, personagem.xp_base, personagem.gold, personagem.id]
        );

    } catch (error) {
        console.error("Erro ao salvar personagem:", error);
        throw error;
    }
};

