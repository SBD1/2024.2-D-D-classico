import client from './db-connection.js';
import chalk from 'chalk';

export const showMap = async (worldId) => {
  // Consulta as salas do mundo com seus respectivos tipos
  const salasQuery = `
    SELECT s.id, s.nome as sala, r.tipo_regiao as tipo
    FROM Salas s
    JOIN Regiao r ON s.id_regiao = r.id
    WHERE r.id_mundo = $1
    ORDER BY s.id;
  `;
  const { rows: salas } = await client.query(salasQuery, [worldId]);

  // Consulta os caminhos (conexões) para as salas do mundo
  const caminhosQuery = `
    SELECT c.sala_origem, c.sala_destino
    FROM Caminhos c
    WHERE c.sala_origem IN (
      SELECT id FROM Salas WHERE id_regiao IN (SELECT id FROM Regiao WHERE id_mundo = $1)
    )
    AND c.sala_destino IN (
      SELECT id FROM Salas WHERE id_regiao IN (SELECT id FROM Regiao WHERE id_mundo = $1)
    )
  `;
  const { rows: caminhos } = await client.query(caminhosQuery, [worldId]);

  // Cria um objeto com os dados de cada sala
  const roomsById = {};
  salas.forEach(sala => {
    // Use trim() para remover espaços extras, caso existam
    roomsById[sala.id] = { name: sala.sala.trim(), type: sala.tipo, connections: [] };
  });

  // Preenche as conexões (supondo caminhos bidirecionais)
  caminhos.forEach(caminho => {
    if (roomsById[caminho.sala_origem])
      roomsById[caminho.sala_origem].connections.push(caminho.sala_destino);
    if (roomsById[caminho.sala_destino])
      roomsById[caminho.sala_destino].connections.push(caminho.sala_origem);
  });

  // Agrupa as salas por tipo (supondo: 'D' para Dungeons, 'F' para Florestas e 'C' para Cidades)
  const groups = { D: [], F: [], C: [] };
  salas.forEach(sala => {
    if (groups[sala.tipo]) {
      groups[sala.tipo].push(sala);
    }
  });

  const typeLabels = { D: "Dungeons", F: "Florestas", C: "Cidades" };

  console.clear();
  console.log(chalk.bold.green("\nMAPA DO MUNDO\n"));

  // Para cada grupo, exibe uma linha com os nós (salas) conectados por setas
  Object.keys(groups).forEach(type => {
    const groupRooms = groups[type];
    // Use trim() para remover espaços extras no nome
    const nodes = groupRooms.map(sala => chalk.yellow(`[${sala.sala.trim()}]`));
    const line = chalk.blue.bold(`${typeLabels[type]}: `) + nodes.join(chalk.white(" → "));
    console.log(line);
  });
  console.log(""); // linha em branco

  // Monta uma lista das interconexões (conexões entre salas de tipos diferentes)
  const interConnections = new Set();
  caminhos.forEach(caminho => {
    const roomA = roomsById[caminho.sala_origem];
    const roomB = roomsById[caminho.sala_destino];
    if (roomA && roomB && roomA.type !== roomB.type) {
      // Para evitar duplicatas, cria uma chave ordenada
      const key = [Math.min(caminho.sala_origem, caminho.sala_destino),
                   Math.max(caminho.sala_origem, caminho.sala_destino)].join("-");
      interConnections.add(key);
    }
  });

  if (interConnections.size > 0) {
    console.log(chalk.magenta.bold("Interconexões entre Grupos:"));
    interConnections.forEach(key => {
      const [idA, idB] = key.split("-").map(Number);
      const roomA = roomsById[idA];
      const roomB = roomsById[idB];
      console.log(
        chalk.yellow(`[${roomA.name} (${typeLabels[roomA.type]})]`) +
        chalk.white(" ↔ ") +
        chalk.yellow(`[${roomB.name} (${typeLabels[roomB.type]})]`)
      );
    });
    console.log("");
  }
};
