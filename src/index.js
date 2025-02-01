#! /usr/bin/env node

import { connect } from './db-connection.js';
import { needSeedTable, seedDBTables } from './sql-loader.js';
import { select, input } from '@inquirer/prompts';
import { registerPlayer, getPlayerCurrentLocation, updatePlayerLocation } from './entities/personagem.entity.js'
import { insertPlayerToDB, getRacas, getClasses } from './playerRepository.js';
import taskQueue from './action-queue.js';
import printDragon from './dragon.js';
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
  console.log('Bem vindo ao D&D classico\n');
  printDragon()

  const answer = await select({
    message: 'Escolha o que quer fazer',
    choices: [
      { name: 'Sair', value: 'exit' },
      { name: 'Entrar', value: 'enter' },
    ]
  });

  if (answer === 'exit') {
    console.log("Saindo");
    process.exit(0);
  } else {
    taskQueue.enqueue(registerPlayerOption);
  }
};

const registerPlayerOption = async () => {
  console.log("=== ETAPA 1 - Escolha a raça do seu personagem ===");
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
    console.log("\n=== ETAPA 2 - Digite o número correspondente à ação que deseja realizar ===");
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

  const name = await input({
    message: 'Qual o nome do seu personagem?',
    default: 'Player',
    required: true
  });

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

  const player = await insertPlayerToDB(playerData);
  console.log("\nSeu personagem foi criado com sucesso:");
  Object.entries(player).forEach(([key, value]) => {
    if (key !== "id") console.log(`${key}: ${value}`);
  });

  taskQueue.enqueue(() => walk(player));
};



const walk = async (player) => {
  if (!player || !player.id) {
    throw new Error("Erro: player está indefinido ou sem ID!");
  }

  const outrasSalas = await getPlayerCurrentLocation(player.id);

  const answer = await select({
    message: "Salas disponíveis para mudar",
    choices: outrasSalas.map(i => ({
      name: i.nome,
      value: i.id
    })),
  })

  await updatePlayerLocation(answer, player.id);
  console.clear();
  taskQueue.enqueue(() => walk(player));
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






