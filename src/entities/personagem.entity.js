import client from "../db-connection.js";

export const registerPlayer = async (name) => {
  if (!name) {
    console.error("O jogador precisa de um nome");
  }
  const body = {
    id_sala: 1,
    id_classe: 1,
    nome: "'"+name.slice(0, -1)+"'",
    id_rac: 1,
    tipo_personagem: `'PC'`,
    vida: 100,
    nivel: 1,
    xp_base: 1,
    destreza: 1,
    carisma: 1,
    forca: 1,
    constituicao: 1,
    sabedoria: 1,
    inteligencia: 1,
    gold: 10,
  };
  
  const { rows } = await client.query(
    `INSERT INTO personagem(id_sala, id_classe, nome, id_raca, tipo_personagem, vida, nivel, xp_base, destreza, carisma, forca, constituicao, sabedoria, inteligencia, gold)  
    VALUES (${Object.values(body).toString()}) RETURNING *`,
  );
  
  const { rows: playerRows} = await client.query(
    `SELECT p.*, r.nome as raca, c.nome as classe FROM personagem p
      INNER JOIN raca r ON p.id_raca = r.id
      INNER JOIN classe c ON c.id = p.id_classe
      WHERE p.id = $1
      `,
    [rows[0].id]
  );
  
  let formatedPLayer ={};
  for (const keys of Object.keys(playerRows[0])) {
    if (!keys.includes("id_")) {
      formatedPLayer[keys] = playerRows[0][keys];
    }
  }
  return formatedPLayer;
};

export const getPlayerCurrentLocation = async (playerId) => {
  const { rows: currentLocation } = await client.query(
    `SELECT r.*, s.nome as sala  FROM regiao r 
    INNER JOIN salas s on r.id = s.id_regiao
    INNER JOIN personagem p on p.id_sala = s.id
    WHERE p.id = $1
    `,
    [playerId]
  );
  console.log(`Localização atual:
    - Região: ${currentLocation[0].nome}
    - Descrição: ${currentLocation[0].descricao}
    - Sala: ${currentLocation[0].sala}`);
  const { rows } = await client.query(
    `SELECT sd.id, sd.nome  FROM caminhos c 
      INNER JOIN salas so on so.id= c.sala_origem 
      INNER JOIN salas sd on sd.id= c.sala_destino 
      INNER JOIN personagem p on p.id_sala = so.id
      WHERE p.id = $1;
      `,
    [playerId]
  );
  return rows;
};

export const updatePlayerLocation = async (idSala,playerId) => {
  await client.query(`UPDATE personagem SET id_sala=${idSala} WHERE id=${playerId};`);
};
