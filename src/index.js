#! /usr/bin/env node

import { connect } from './db-connection.js';
import { needSeedTable, seedDBTables } from './sql-loader.js';
import { select, input } from '@inquirer/prompts';
import { registerPlayer, getPlayerCurrentLocation, updatePlayerLocation } from './entities/personagem.entity.js'
import { insertPlayerToDB, getRacas, getClasses } from './playerRepository.js';
import taskQueue from './action-queue.js';
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

  const answer = await select({
    message: 'Escolha o que quer fazer',
    choices: [
      {
        name: 'Sair',
        value: 'exit',
      },
      {
        name: 'Entrar',
        value: 'enter',
      },
    ]
  });

  if (answer === 'exit') {
    console.log("Saindo");
    process.exit(0);
  } else {
    taskQueue.enqueue(() => registerPlayerOption()); // Enfileira a função corretamente

  }
}

const registerPlayerOption = async () => {
  console.log("=== Escolha sua raça ===");
  const racas = await getRacas();
  racas.forEach(({ id, nome }) => console.log(`${id}: ${nome}`));

  let id_raca;
  while (true) {
    id_raca = await input({ message: 'Digite o ID da sua raça:', required: true });
    if (racas.some(r => r.id === parseInt(id_raca))) break;
    console.log("Raça inválida! Escolha um ID válido.");
  }

  console.log("\n=== Escolha sua classe ===");
  const classes = await getClasses();
  classes.forEach(({ id, nome }) => console.log(`${id}: ${nome}`));

  let id_classe;
  while (true) {
    id_classe = await input({ message: 'Digite o ID da sua classe:', required: true });
    if (classes.some(c => c.id === parseInt(id_classe))) break;
    console.log("Classe inválida! Escolha um ID válido.");
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
    xp_base: 1,
    destreza: 1,
    carisma: 1,
    forca: 1,
    constituicao: 1,
    sabedoria: 1,
    inteligencia: 1,
    gold: 10,
  };

  const player = await insertPlayerToDB(playerData);
  console.log("Player retornado:", player);


  console.log("\nSeu personagem foi criado com sucesso:");
  Object.entries(player).forEach(([key, value]) => {
    if (key !== "id") console.log(`${key}: ${value}`);
  });
  taskQueue.enqueue(() => walk(player));  // Enfileira a função corretamente

};

export default registerPlayerOption;

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
  console.clear()
  taskQueue.enqueue(() => walk(player));  // Enfileira a função corretamente

}


await welcome();
taskQueue.enqueue(mainMenu);
// main loop
while (true) {
  try {
    const currentFunction = taskQueue.dequeue();

    console.log("Tarefa retirada da fila:", currentFunction); // Verifique o que está sendo retirado da fila

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






