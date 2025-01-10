#! /usr/bin/env node
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const db_connection_1 = require("./db-connection");
// import chalk from 'chalk';
// import inquirer from 'inquirer';
// import gradient from 'gradient-string';
// import chalkAnimation from 'chalk-animation';
// import figlet from 'figlet';
// import { createSpinner } from 'nanospinner';
// Learn more at https://docs.deno.com/runtime/manual/examples/module_metadata#concepts
console.log("Hi");
console.error("Hi");
(0, db_connection_1.connect)();
//# sourceMappingURL=index.js.map