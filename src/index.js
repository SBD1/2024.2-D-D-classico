#! /usr/bin/env node

import { connect } from './db-connection.js';
import { needSeedTable, seedDBTables } from './sql-loader.js';
import { select, input } from '@inquirer/prompts';
import { registerPlayer, getPlayerCurrentLocation, updatePlayerLocation } from './entities/personagem.entity.js'
import { insertPlayerToDB, getRacas, getClasses, getPlayerStatus, getPlayerByName, getEntitiesInRoom } from './playerRepository.js';
import taskQueue from './action-queue.js';
import printDragon from './dragon.js';
import chalk from 'chalk';
// import inquirer from 'inquirer'; 
// import gradient from 'gradient-string';
// import chalkAnimation from 'chalk-animation';
// import figlet from 'figlet';
// import { createSpinner } from 'nanospinner';

let player;

const welcome = async () => {
  console.log(`Bem vindo ao D&D classico
    (use as setas para navegar e enter para selecionar)`);


  await connect();
  const needSeedTableBol = await needSeedTable();
  if (needSeedTableBol) {
    await seedDBTables();
  }
  console.clear();
}

const mainMenu = async () => {
  console.log('Bem vindo ao D&D Clássico\n');
  printDragon();

  const answer = await select({
    message: 'Escolha o que quer fazer',
    choices: [
      { name: 'Cadastrar', value: 'register' },
      { name: 'Entrar', value: 'login' },
      { name: 'Sair', value: 'exit' },
    ]
  });

  if (answer === 'exit') {
    console.log("Saindo...");
    process.exit(0);
  } else if (answer === 'register') {
    taskQueue.enqueue(registerPlayerOption);
  } else if (answer === 'login') {
    taskQueue.enqueue(loginPlayer);
  }
};

const loginPlayer = async () => {
  const name = await input({ message: 'Digite o nome do seu personagem:' });

  const playerData = await getPlayerByName(name);

  if (!playerData) {
    console.log(chalk.red("Personagem não encontrado! Tente novamente."));
    taskQueue.enqueue(mainMenu);
    return;
  }

  console.log(chalk.green(`Bem-vindo de volta, ${playerData.nome}!`));
  taskQueue.enqueue(() => walk(playerData));
};



const registerPlayerOption = async () => {
  console.log(chalk.bold.hex('#FF6347')("=== ETAPA 1 - Escolha a raça do seu personagem ==="));
  const racas = await getRacas();
  racas.forEach(({ id, nome }) => console.log(`${id}: ${nome}`));

  let id_raca;
  while (true) {
    id_raca = await input({ message: 'Digite o ID da sua raça:', required: true });
    if (racas.some(r => r.id === parseInt(id_raca))) break;
    console.log("Raça inválida! Escolha um ID válido.");
  }

  const classes = [
    { id: 1, nome: "Bárbaro", xp_base: 0, destreza: 15, carisma: 8, forca: 18, constituicao: 16, sabedoria: 10, inteligencia: 8 },
    { id: 2, nome: "Bardo", xp_base: 0, destreza: 14, carisma: 16, forca: 10, constituicao: 12, sabedoria: 12, inteligencia: 14 },
    { id: 3, nome: "Clérigo", xp_base: 0, destreza: 10, carisma: 12, forca: 12, constituicao: 14, sabedoria: 18, inteligencia: 14 },
    { id: 4, nome: "Druida", xp_base: 0, destreza: 12, carisma: 10, forca: 14, constituicao: 15, sabedoria: 16, inteligencia: 13 },
    { id: 5, nome: "Guerreiro", xp_base: 0, destreza: 14, carisma: 10, forca: 18, constituicao: 16, sabedoria: 10, inteligencia: 12 },
    { id: 6, nome: "Monge", xp_base: 0, destreza: 16, carisma: 10, forca: 14, constituicao: 15, sabedoria: 14, inteligencia: 12 },
    { id: 7, nome: "Paladino", xp_base: 0, destreza: 12, carisma: 16, forca: 14, constituicao: 16, sabedoria: 12, inteligencia: 10 },
    { id: 8, nome: "Patrulheiro", xp_base: 0, destreza: 16, carisma: 10, forca: 14, constituicao: 14, sabedoria: 12, inteligencia: 12 },
    { id: 9, nome: "Ladino", xp_base: 0, destreza: 18, carisma: 12, forca: 10, constituicao: 14, sabedoria: 10, inteligencia: 14 },
    { id: 10, nome: "Feiticeiro", xp_base: 0, destreza: 10, carisma: 12, forca: 8, constituicao: 12, sabedoria: 12, inteligencia: 18 },
    { id: 11, nome: "Bruxo", xp_base: 0, destreza: 12, carisma: 14, forca: 10, constituicao: 12, sabedoria: 12, inteligencia: 16 },
    { id: 12, nome: "Mago", xp_base: 0, destreza: 10, carisma: 12, forca: 8, constituicao: 10, sabedoria: 14, inteligencia: 18 },
  ];

  let id_classe;
  while (true) {
    console.log(chalk.bold.hex('#FF6347')("\n=== ETAPA 2 - Digite o número correspondente à ação que deseja realizar ==="));
    console.log("1 - Escolher Classe");
    console.log("2 - Visualizar atributos de cada classe");

    const escolha = await input({ message: 'Digite sua escolha:', required: true });

    if (escolha === '1') {
      console.log("\n=== Escolha sua classe ===");
      classes.forEach(({ id, nome }) => console.log(`${id}: ${nome}`));

      while (true) {
        id_classe = await input({ message: 'Digite o ID da sua classe:', required: true });
        if (classes.some(c => c.id === parseInt(id_classe))) break;
        console.log("Classe inválida! Escolha um ID válido.");
      }
      break;
    }

    if (escolha === '2') {
      console.log("\n=== Escolha a classe que deseja visualizar ===");
      classes.forEach(({ id, nome }) => console.log(`${id}: ${nome}`));

      let id_visualizar;
      while (true) {
        id_visualizar = await input({ message: 'Digite o ID da classe para visualizar:', required: true });
        const classeSelecionada = classes.find(c => c.id === parseInt(id_visualizar));
        if (classeSelecionada) {
          console.log("\n=== Atributos da Classe ===");
          Object.entries(classeSelecionada).forEach(([key, value]) => {
            if (key !== "id" && key !== "nome") console.log(`${key}: ${value}`);
          });
          console.log("\n");
          break;
        }
        console.log("ID inválido! Escolha um ID válido.");
      }
    }
  }

  let name;
  let playerCreated = false;
  while (!playerCreated) {
    name = await input({
      message: 'Qual o nome do seu personagem?',
      default: 'Player',
      required: true
    });

    try {
      const playerData = {
        id_sala: 1,
        id_classe: parseInt(id_classe),
        nome: name,
        id_raca: parseInt(id_raca),
        tipo_personagem: 'PC',
        vida: 100,
        nivel: 1,
        xp_base: classes.find(c => c.id === parseInt(id_classe)).xp_base,
        destreza: classes.find(c => c.id === parseInt(id_classe)).destreza,
        carisma: classes.find(c => c.id === parseInt(id_classe)).carisma,
        forca: classes.find(c => c.id === parseInt(id_classe)).forca,
        constituicao: classes.find(c => c.id === parseInt(id_classe)).constituicao,
        sabedoria: classes.find(c => c.id === parseInt(id_classe)).sabedoria,
        inteligencia: classes.find(c => c.id === parseInt(id_classe)).inteligencia,
        gold: 10,
      };

      // Tenta inserir o jogador no banco de dados
      const player = await insertPlayerToDB(playerData);
      console.log("\nSeu personagem foi criado com sucesso:");
      console.log(`Nome: ${player.nome}`);
      Object.entries(player).forEach(([key, value]) => {
        if (key !== "id") console.log(`${key}: ${value}`);
      });

      playerCreated = true;
      taskQueue.enqueue(() => walk(player));
    } catch (error) {
      if (error.message === 'Nome de personagem já existente.') {
        // Se o erro for de duplicidade
        console.log(chalk.bold.hex('#FF6347')("Tente Novamente:"));
      } else {
        console.error("Erro ao criar personagem:", error);
      }
    }
  }
};

const showPlayerStatus = async (player, previousMenu) => {
  if (!player || !player.id) {
    console.log("Nenhum jogador encontrado.");
    return;
  }

  const status = await getPlayerStatus(player.id);
  if (!status) return;

  console.log(chalk.bold.hex('#FFD700')("\n=== STATUS DO PERSONAGEM ==="));
  Object.entries(status).forEach(([key, value]) => {
    console.log(`${key.toUpperCase()}: ${value}`);
  });

  await input({ message: "Pressione Enter para continuar..." });

  taskQueue.enqueue(() => previousMenu(player));
};

const listarPersonagens = async (sala) => {
  const entities = await getEntitiesInRoom(sala);

  console.clear();
  console.log("\n=== Personagens na sala ===");

  if (entities.length > 0) {
    entities.forEach(({ nome, tipo_personagem }) => {
      console.log(`  - ${nome} (${tipo_personagem})`);
    });
  } else {
    console.log("\n⚠️ Nenhum NPC ou inimigo na sala.");
  }

  await input({ message: "Pressione Enter para voltar" });
};


const walk = async (player) => {
  if (!player || !player.id) {
    throw new Error("Erro: player está indefinido ou sem ID!");
  }

  const outrasSalas = await getPlayerCurrentLocation(player.id);

  console.clear();
  console.log(`\n=== Você está atualmente em uma sala ===`);

  if (outrasSalas.length > 0) {
    console.log("\n🔹 Salas disponíveis para viajar:");
    outrasSalas.forEach((sala, index) => {
      console.log(`  ${index + 1}. ${sala.nome} (ID: ${sala.id})`);
    });
  } else {
    console.log("\n⚠️ Nenhuma sala disponível para viajar.");
  }

  console.log("\n=== Escolha uma ação ===");

  const answer = await select({
    message: "O que deseja fazer?",
    choices: [
      ...outrasSalas.map(i => ({
        name: `Ir para: ${i.nome}`,
        value: i.id
      })),
      { name: "Exibir Status", value: "status" },
      { name: "Listar personagens na sala", value: "listar_personagens" },
      { name: "Sair do jogo", value: "exit" }
    ],
  });

  if (answer === "status") {
    taskQueue.enqueue(() => showPlayerStatus(player, walk));
  } else if (answer === "listar_personagens") {
    await listarPersonagens(player.id_sala);
    taskQueue.enqueue(() => walk(player));
  } else if (answer === "exit") {
    console.log("Saindo do jogo...");
    process.exit(0);
  } else {
    const novasala_id = await updatePlayerLocation(answer, player.id);
    player.id_sala = novasala_id; 
    console.clear();
    taskQueue.enqueue(() => walk(player));  
  }
};

await welcome();
taskQueue.enqueue(mainMenu);
// main loop
while (true) {
  try {
    const currentFunction = taskQueue.dequeue();

    if (!currentFunction) {
      taskQueue.enqueue(mainMenu);
    } else if (typeof currentFunction === "function") {
      await currentFunction();
    } else {
      console.error("Erro: A tarefa na fila não é uma função:", currentFunction);
      process.exit(1);
    }
  } catch (error) {
    console.error("A aplicação encontrou um erro:", error);
    process.exit(1);
  }
}






