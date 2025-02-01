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
        await client.query('INSERT INTO inventario (id_pc, id_instancia_item, capacidade) VALUES ($1, $2, 1) ON CONFLICT (id_pc, id_instancia_item) DO UPDATE SET capacidade = inventario.capacidade + 1', [playerId, mission.rows[0].recompensa]);
    }
    showDialogue('Mission completed!');
}
