#! /usr/bin/env node

import chalk from 'chalk';

import {connect} from './db-connection.js';
import { clearNLines, sleep } from './utils.js';

// import inquirer from 'inquirer'; 
// import gradient from 'gradient-string';
// import chalkAnimation from 'chalk-animation';
// import figlet from 'figlet';
// import { createSpinner } from 'nanospinner';

const welcome = async () => {
  console.log("Bem vindo ao D&D classico");
  await connect(); 
}

await welcome()

  // console.log(chalk.red("oidoCiro"));
// }
// Learn more at https://docs.deno.com/runtime/manual/examples/module_metadata#concepts



