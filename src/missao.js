import client from './db-connection.js';
import promptSync from 'prompt-sync';
const prompt = promptSync();

function showDialogue(text) {
    console.log(text);
    prompt('Pressione Enter para continuar...');
}

export async function startMission(playerId, missionId) {
    await client.query('INSERT INTO inst_missao (id_personagem, missao) VALUES ($1, $2)', [playerId, missionId]);
    const dialogue = await client.query('SELECT * FROM dialogo WHERE missao = $1 ORDER BY id LIMIT 1', [missionId]);
    showDialogue(dialogue.rows[0].conteudo); // Exibe o diálogo e espera "Enter"
    console.log('Missão iniciada!');
}

export async function completeMission(playerId, missionId) {
    const mission = await client.query('SELECT recompensa_gold, recompensa FROM missao WHERE id = $1', [missionId]);
    //await client.query('UPDATE player_missions SET status = $1 WHERE player_id = $2 AND mission_id = $3', ['completed', playerId, missionId]);
    await client.query('UPDATE personagem SET gold = gold + $1 WHERE id = $2', [mission.rows[0].recompensa_gold, playerId]);
    if (mission.rows[0].recompensa) {
        await client.query('INSERT INTO inventario (id_pc, id_instancia_item) VALUES ($1, $2)', [playerId, mission.rows[0].recompensa]);
    }
    showDialogue('Mission completed!');
}

/**
 * Atualiza o progresso de missões que exigem inimigos de uma determinada raça.
 *
 * @param {number} playerId - ID do personagem (jogador)
 * @param {number} enemyRacaId - ID da raça do inimigo derrotado
 */
export const updateMissionProgressOnEnemyDefeat = async (playerId, enemyRacaId) => {
  try {
    // Seleciona todas as missões ativas para o jogador cuja missão exige a raça do inimigo
    const missionRes = await client.query(
      `SELECT im.missao, m.kills_requeridas, im.progresso
       FROM Inst_Missao im
       JOIN Missao m ON im.missao = m.id
       WHERE im.id_personagem = $1 
         AND im.status = 'ativa'
         AND m.id_raca = $2`,
      [playerId, enemyRacaId]
    );
    
    if (missionRes.rows.length === 0) {
      // Nenhuma missão exige inimigos desta raça
      return;
    }
    
    // Para cada missão encontrada, incrementa o progresso
    for (const mission of missionRes.rows) {
      // Incrementa o progresso em 1 para cada inimigo derrotado
      await client.query(
        `UPDATE Inst_Missao 
         SET progresso = progresso + 1
         WHERE id_personagem = $1 AND missao = $2`,
        [playerId, mission.missao]
      );
      
      // Busca o novo valor de progresso
      const progressRes = await client.query(
        `SELECT progresso FROM Inst_Missao 
         WHERE id_personagem = $1 AND missao = $2`,
        [playerId, mission.missao]
      );
      
      const novoProgresso = progressRes.rows[0].progresso;
      
      // Se o progresso atingiu ou ultrapassou o número requerido, finaliza a missão
      if (novoProgresso >= mission.kills_requeridas) {
        await client.query(
          `UPDATE Inst_Missao 
           SET status = 'completa'
           WHERE id_personagem = $1 AND missao = $2`,
          [playerId, mission.missao]
        );
        
        console.log(`Missão ${mission.missao} concluída! Recompensa aplicada.`);
        completeMission(playerId, mission.missao);
      } else {
        console.log(`Missão ${mission.missao}: progresso ${novoProgresso}/${mission.kills_requeridas}`);
      }
    }
    
  } catch (error) {
    console.error("Erro ao atualizar o progresso da missão:", error);
  }
};

export const getMissionsForCity = async (salaId) => {
    try {
      const res = await client.query(
        `SELECT id, titulo, objetivo, recompensa_gold 
         FROM Missao 
         WHERE id_sala = $1`,
        [salaId]
      );
      return res.rows; // retorna um array de missões (pode estar vazio)
    } catch (error) {
      console.error("Erro ao buscar missões para a cidade:", error);
      return [];
    }
  };

  export const getMissionDialogues = async (missionId) => {
    try {
      const res = await client.query(
        `SELECT conteudo 
         FROM Dialogo 
         WHERE missao = $1
         ORDER BY id ASC`, // garante a ordem dos diálogos
        [missionId]
      );
      return res.rows; // cada linha terá o campo 'conteudo'
    } catch (error) {
      console.error("Erro ao buscar diálogos da missão:", error);
      return [];
    }
  };

  export const acceptMission = async (playerId, missionId) => {
    try {
      await client.query(
        `INSERT INTO Inst_Missao (missao, id_personagem, progresso, status) 
         VALUES ($1, $2, 0, 'ativa')`,
        [missionId, playerId]
      );
    } catch (error) {
      console.error("Erro ao aceitar a missão:", error);
    }
  };