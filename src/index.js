#! /usr/bin/env node

import { connect } from './db-connection.js';
import { comprarItem } from './loja.js';
import { getLojaNaSala } from './lojaRepository.js';
import { needSeedTable, seedDBTables } from './sql-loader.js';
import { select, input } from '@inquirer/prompts';
import { registerPlayer, getPlayerCurrentLocation, updatePlayerLocation, getPlayerLocal } from './entities/personagem.entity.js'
import { insertPlayerToDB, getRacas, getClasses,getPlayerEquippedItems, getPlayerStatus, getPlayerByName, getEnemiesInRoom, getPlayerInventory, getPlayerInventoryCount, salvarPersonagem } from './playerRepository.js';
import taskQueue from './action-queue.js';
import printDragon from './dragon.js';
import chalk from 'chalk';
import { startMission,completeMission } from './missao.js';
import { chooseWorld, getWorldByPlayerId, getRandomSalaForWorld } from './worldRepository.js';
import { showMap } from './map.entity.js';
import { equiparItem, desequiparItem } from './playerRepository.js';

import promptSync from 'prompt-sync';
const prompt = promptSync();

function showDialogue(text) {
    console.log(text);
}


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
  const worldId = await chooseWorld(); // o jogador escolhe o mundo
  const randomSala = await getRandomSalaForWorld(worldId); // sala aleatória para o mundo escolhido
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
        id_sala: randomSala.id,
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

const listarInimigos = async (salaId) => {
  const entities = await getEnemiesInRoom(salaId);

  if (entities.length === 0) {
    console.clear();
    console.log("\n⚠️ Nenhum inimigo nesta sala!");
    await input({ message: "Pressione Enter para voltar" });
    return null;
  }

  const escolha = await select({
    message: "Selecione um inimigo para lutar:",
    choices: [
      ...entities.map(entity => ({
        name: `${entity.nome} (${entity.tipo_personagem}) [lvl. ${entity.nivel}]`,
        value: entity
      })),
      { name: "Voltar", value: null }
    ],
    pageSize: 5 // Mostra 5 opções por vez
  });

  return escolha;
};

const iniciarCombate = async (jogador, inimigo) => {
  if (!inimigo?.id) {
    throw new Error("Inimigo sem ID válido!");
  }

  console.clear();
  console.log(`⚔️ Combate contra ${inimigo.nome} (Nível ${inimigo.nivel}) ⚔️\n`);

  while (jogador.vida > 0 && inimigo.vida > 0) {
    console.log(`Jogador: ${jogador.vida} HP`);
    console.log(`Inimigo: ${inimigo.vida} HP\n`);

    // Turno do jogador
    const acao = await select({
      message: "Escolha uma ação:",
      choices: [
        { name: "Atacar", value: "atacar" },
        { name: "Fugir", value: "fugir" }
      ]
    });

    if (acao === "fugir") {
      const chanceFuga = 50; // 50% de chance de fugir
      if (Math.random() * 100 < chanceFuga) {
        console.log("\nVocê fugiu do combate!");
        await salvarPersonagem(jogador);
        await salvarPersonagem(inimigo);
        await input({ message: "Pressione Enter para continuar" });
        return;
      } else {
        console.log("\nFalha na fuga!");
      }
    }

    // Ataque do jogador
    inimigo.vida -= jogador.forca;
    console.log(`\nVocê causou ${jogador.forca} de dano!`);

    // Ataque do inimigo se ainda estiver vivo
    if (inimigo.vida > 0) {
      jogador.vida -= inimigo.forca;
      console.log(`${inimigo.nome} causou ${inimigo.forca} de dano!`);
    }

    await input({ message: "Pressione Enter para continuar" });
    console.clear();
  }

  // Resultado do combate
  if (jogador.vida <= 0) {
    console.log("💀 Você foi derrotado!");
    jogador.vida = 0;
    await salvarPersonagem(jogador);
    process.exit(0);
  } else {
    console.log(`🎉 ${inimigo.nome} foi derrotado!`);
    console.log(`Você ganhou ${inimigo.xp_base} XP e ${inimigo.gold} gold!`);

    // Atualiza jogador
    jogador.xp_base += inimigo.xp_base;
    jogador.gold += inimigo.gold;

    // Level up simples
    if (jogador.xp_base >= 100 * jogador.nivel) {
      jogador.nivel++;
      jogador.vida += 10;
      console.log(`⭐ Subiu para o nível ${jogador.nivel}!`);
    }

    inimigo.vida = 0;

    await salvarPersonagem(jogador);
    await salvarPersonagem(inimigo);

    await input({ message: "Pressione Enter para continuar" });
  }
};

const walk = async (player) => {
  if (!player || !player.id) {
    throw new Error("Erro: player está indefinido ou sem ID!");
  }
  // Busca salas disponíveis para movimentação
  const outrasSalas = await getPlayerCurrentLocation(player.id);
  const local = await getPlayerLocal(player.id);
  const loja = await getLojaNaSala(player.id_sala);
  console.clear();
  console.log(chalk.bold.hex('#FFD700')(`\nVocê está atualmente em ${local.substring(0, 40)}`));

  if (outrasSalas.length > 0) {
    console.log("\n🔹 Salas disponíveis para viajar:");
    outrasSalas.forEach((sala, index) => {
      console.log(`  ${index + 1}. ${sala.nome.substring(0,40)}`);
    });
  } else {
    console.log("\n⚠️ Nenhuma sala disponível para viajar.");
  }

  console.log("\n=== Escolha uma ação ===");
  
 
  const choices = outrasSalas.map(i => ({
    name: `Ir para ${i.nome.substring(0,40)}`,
    value: `${i.id}`
  }));
  if (loja && loja.length > 0) {
    loja.forEach(l => {
      choices.push({ name: `Visitar ${l.nome} (${l.tipo})`, value: `loja_${l.id}` });
    });
  }
  choices.push({name: "Exibir Status", value: "status" });
  choices.push({ name:"Ver inimigos na sala", value: "listar_inimigos" });
  choices.push({ name:"Visualizar Inventário", value: "inventory"});
  choices.push({ name:"Mostrar Mapa", value: "mapa" });
  choices.push({ name: 'Sair do jogo', value: 'exit' });
  
  choices.push({ name: 'Equipar Item', value: 'equipar'  });
  choices.push({ name: 'Desequipar Item', value: 'desequipar'});
 
  const answer = await select({
    message: "O que deseja fazer?",
    choices
  });

  if (answer === "status") {
    taskQueue.enqueue(() => showPlayerStatus(player, walk));
  } else if (answer === "mapa") {
    // Primeiro, recupere o mundo atual do jogador
    const currentWorldId = await getWorldByPlayerId(player.id);
    await showMap(currentWorldId);
    await input({ message: "Pressione Enter para continuar..." });
    taskQueue.enqueue(() => walk(player));
  } else if (answer === "inventory") {
    await showInventory(player);
    taskQueue.enqueue(() => walk(player));
  } else if (answer.startsWith('loja_')) {
    const lojaId = parseInt(answer.replace('loja_', '')); // Extrai o ID da loja corretamente
    await comprarItem(player.id, lojaId);
    taskQueue.enqueue(() => walk(player));
  } else if (answer === "listar_inimigos") {
    const inimigo = await listarInimigos(player.id_sala);
    if (inimigo) {
      taskQueue.enqueue(() => iniciarCombate(player, inimigo));
      taskQueue.enqueue(() => walk(player));
    } else {
      taskQueue.enqueue(() => walk(player));
    }
  } else if (answer === "exit") {
    console.log("Saindo do jogo...");
    process.exit(0);
  } 
  else if (answer === 'equipar') {
    const itemId = await input({ message: 'Digite o ID do item para equipar:', required: true });
    await equiparItem(player.id, parseInt(itemId));
    taskQueue.enqueue(() => walk(player));
  } else if (answer === 'desequipar') {
    const itemId = await input({ message: 'Digite o ID do item para desequipar:', required: true });
    await desequiparItem(player.id, parseInt(itemId));
    taskQueue.enqueue(() => walk(player));
  } else {
    const novasala_id = await updatePlayerLocation(answer, player.id);
    player.id_sala = novasala_id;
    console.clear();
    taskQueue.enqueue(() => walk(player));
  }
};


const showInventory = async (player) => {
  // Recupera os itens do inventário do jogador
  const inventory = await getPlayerInventory(player.id);

  if (!inventory || inventory.length === 0) {
    console.log(chalk.red("Erro ao buscar inventário ou inventário vazio!"));
    await input({ message: "Pressione Enter para continuar..." });
  } else {
    // Recupera os itens atualmente equipados
    const equippedItems = await getPlayerEquippedItems(player.id);
    
    // Monta o menu de seleção
    const choices = inventory.map((item, index) => {
      // Verifica se o item está equipado (compara pelo id)
      const isEquipped = equippedItems.rows.some(e => e.id === item.id);
     

      return {
        name: `${index + 1}. ${item.nome} (Qtd: ${item.quantidade}) ${isEquipped ? '[Equipado]' : ''}`,
        value: item.id,
        // Também podemos incluir o tipo para facilitar as verificações posteriores
        tipo_item: item.tipo_item 
      };
    });
    // Adiciona uma opção para voltar ou sair
    choices.push({ name: 'Voltar', value: 'voltar' });

    console.log(chalk.bold.hex('#FFD700')("\n=== INVENTÁRIO DO JOGADOR ==="));
    // Exibe a capacidade do inventário
    const inventoryCapacity = await getPlayerInventoryCount(player.id);
    console.log(`Capacidade: ${inventoryCapacity}/20`);

    // Solicita que o jogador selecione um item
    const answer = await select({
      message: "Selecione um item para equipar/desequipar:",
      choices
    });

    if (answer === 'voltar') {
      return; // Volta ao menu anterior
    }

    // Identifica o item selecionado (buscando no array de choices ou no inventário)
    const selectedItem = choices.find(c => c.value === answer);
    if (!selectedItem) {
      showDialogue(chalk.red("Item inválido.")); 
      return;
    }

    // Verifica se o item já está equipado
    const isAlreadyEquipped = equippedItems.rows.some(e => e.id === selectedItem.value);

    if (isAlreadyEquipped) {
      // Desequipar se o item já estiver equipado
      await desequiparItem(player.id, selectedItem.value);
      showDialogue(chalk.green(`${selectedItem.name} foi desequipado.`)); 

    } else {
      // Se for para equipar, verificar restrições: apenas 1 arma e 1 armadura simultaneamente

      if (selectedItem.tipo_item === 'Arma') {
        // Verifica se já existe uma arma equipada
        if (equippedItems.rows.some(e => e.tipo_item === 'Arma')) {
          showDialogue(chalk.red("Você já possui uma arma equipada! Desequipe-a antes de equipar outra."));
          await input({ message: "Pressione Enter para continuar..." });
          
          // Opcional: retornar ou permitir que o jogador tente novamente
          return;
        }
      }
      if (selectedItem.tipo_item === 'Armadura') {
        // Verifica se já existe uma armadura equipada
        if (equippedItems.rows.some(e => e.tipo_item === 'Armadura')) {
          showDialogue(chalk.red("Você já possui uma armadura equipada! Desequipe-a antes de equipar outra.")); 
          await input({ message: "Pressione Enter para continuar..." });
          return;
        }
      }

      // Se passar nas verificações, equipa o item
      await equiparItem(player.id, selectedItem.value);
      showDialogue(chalk.green(`${selectedItem.name} foi equipado.`)); 
    }

    // Aguarda uma confirmação para continuar
    await input({ message: "Pressione Enter para continuar..." });
  }
};

export default showInventory;


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






