#! /usr/bin/env node

import chalk from 'chalk';

import {connect} from './db-connection.js';
import { clearNLines, createProgressBar, sleep } from './utils.js';
import { createDBTables, needCreateTable, needSeedTable, seedDBTables } from './sql-loader.js';
import { select, input } from '@inquirer/prompts';
// import inquirer from 'inquirer'; 
// import gradient from 'gradient-string';
// import chalkAnimation from 'chalk-animation';
// import figlet from 'figlet';
// import { createSpinner } from 'nanospinner';

let player;

const welcome = async () => {
  console.log('Bem vindo ao D&D classico\n');

  
  await connect();
  const needCreateTable = await needCreateTable();
  if (condition) {
    await createDBTables();
  }
  const needSeedTable = await needSeedTable();
  if (needSeedTable) {
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
    process.emit(0);
  }
}

const registerPlayer = async () => {
  const answer = await input({
    message:'Qual o nome do seu personagem',
    default:'Player',
    required:true
  });
  const pl = await registerPlayer(answer);
  player = pl;
}

const walk = async () => {
 const outrasSalas = getPlayerCurrentLocation(player.id);
 const answer = await select({
  message:"Salas disponíveis para mudar",
  choices:outrasSalas.map(i=>({
    name:i.nome,
    val: i.id
  })),
 })

 await updatePlayerLocation(answer,player.id);
 walk();
}


await welcome();
await mainMenu();
await registerPlayer();
await walk();



