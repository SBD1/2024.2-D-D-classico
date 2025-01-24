#! /usr/bin/env node

import {connect} from './db-connection.js';
import { needSeedTable, seedDBTables } from './sql-loader.js';
import { select, input } from '@inquirer/prompts';
import {registerPlayer, getPlayerCurrentLocation, updatePlayerLocation} from './entities/personagem.entity.js'
import taskQueue from './action-queue.js';
// import inquirer from 'inquirer'; 
// import gradient from 'gradient-string';
// import chalkAnimation from 'chalk-animation';
// import figlet from 'figlet';
// import { createSpinner } from 'nanospinner';

let player;

const welcome = async () => {
  console.log('Bem vindo ao D&D classico\n');

  
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
    message:'Escolha o que quer fazer',
    choices: [
      {
        name:'Sair',
        value:'exit',
      },
      {
        name:'Entrar',
        value:'enter',
      },
    ]
  });

  if (answer === 'exit') {
    console.log("Saindo");
    process.exit(0);
  } else {
    taskQueue.enqueue(registerPlayerOption)
  }
}

const registerPlayerOption = async () => {
  const answer = await input({
    message:'Qual o nome do seu personagem',
    default:'Player',
    required:true
  });
  const pl = await registerPlayer(answer);
  console.log("Seu player:");
  for (const key of Object.keys(pl)) {
    if (key !== "id") {
        console.log(`${key} : ${pl[key]}`);
    }
  }
  
  player = pl;
  taskQueue.enqueue(walk)
}

const walk = async () => {
 const outrasSalas = await getPlayerCurrentLocation(player.id);

 const answer = await select({
  message:"Salas disponíveis para mudar",
  choices:outrasSalas.map(i=>({
    name:i.nome,
    value: i.id
  })),
 })
 
 await updatePlayerLocation(answer,player.id);
 console.clear()
 taskQueue.enqueue(walk);
}


await welcome();
taskQueue.enqueue(mainMenu);
// main loop
while(true) {
  try {
    const currentFunction = taskQueue.dequeue();
    if (!currentFunction) {
      taskQueue.enqueue(mainMenu);
    } else {
      await currentFunction();
    }
  } catch (error) {    
    console.error("A aplicação encontrou um erro")
    process.exit(1);
  }
}




