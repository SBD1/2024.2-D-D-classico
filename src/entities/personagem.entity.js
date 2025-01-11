import client from "../db-connection"

export const regiterPlayer = async (name) => {
  if (!name) {
    console.error("O jogador precisa de um nome");
  }
  const { rows } = await client.query(`INSERT personagem(id_sala,nome) VALUES (1,$1)`,[name]);
  return rows[0];
}

export const getPlayerCurrentLocation = async (playerId) => {
  const {rows: currentLocation} = await client.query(`SELECT r.*, s.nome as sala  FROM regiao r 
    INNER JOIN salas s on r.id = s.id_regiao
    INNER JOIN personagem p on p.id_sala = s.id
    WHERE p.id = $1
    `,[playerId]);
  console.log(`Localização atual:
    - Região: ${currentLocation[0].nome}
    - Descrição: ${currentLocation[0].descricao}
    - Sala: ${currentLocation[0].sala}    
    `);  
  const {rows} = await client.query(`SELECT sd.id, sd.nome  FROM caminhos c 
      INNER JOIN salas so on so.id= c.sala_origem 
      INNER JOIN salas sd on sd.id= c.sala_destino 
      INNER JOIN personagem p on p.id_sala = so.id
      WHERE p.id = $1;
      `,[playerId]);
      return rows
}

export const updatePlayerLocation = async (playerId, idSala) => {
  await client.query(`UPDATE personagem SET id_sala=$2 WHERE id=$1;`,[playerId,idSala]);
}