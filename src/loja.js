import { select, input } from '@inquirer/prompts';
import { getPlayerGold, updatePlayerGold, addItemToInventory } from './playerRepository.js';
import { getLojaItens, updateLojaEstoque,getLojas } from './lojaRepository.js';
import chalk from 'chalk';
import promptSync from 'prompt-sync';
const prompt = promptSync();


function showDialogue(text) {
  console.log(text);
  prompt('Pressione Enter para continuar...');
}
export const comprarItem = async (playerId,lojaId) => {
  console.log(playerId)
  
  // 2️⃣ Buscar itens da loja
  const itens = await getLojaItens(lojaId);
  if (itens.length === 0) {
    console.log(chalk.red("Esta loja não tem itens à venda."));
    return;
  }
  const playerGold = await getPlayerGold(playerId);
  console.log(chalk.bold.hex('#FFA500')("\n=== Itens disponíveis ==="));
  console.log(chalk.bold.hex('#04ff23')(`=== Seu gold ${playerGold} ===`));
  itens.forEach(({ id, nome, preco, quantidade }) => {
    console.log(`${id}: ${nome} - Preço: ${preco} gold | Estoque: ${quantidade}`);
  });

  // 3️⃣ Jogador escolhe um item
  const itemId = await input({ message: 'Digite o ID do item que deseja comprar:', required: true });
  const item = itens.find(i => i.id === parseInt(itemId));
  if (!item) {
    console.log(chalk.red("Item inválido!"));
    return;
  }

  // 4️⃣ Jogador escolhe a quantidade
  
  // 5️⃣ Verificar se o jogador tem ouro suficiente
  
  const custoTotal = item.preco ;

  if (playerGold < custoTotal) {
    console.log(chalk.red("Você não tem ouro suficiente!"));
    return;
  }

  // 6️⃣ Realizar compra
  try {
    await updatePlayerGold(playerId, playerGold - custoTotal);
  } catch (error) {
    console.error('Erro ao atualizar ouro do jogador:', error);
    return;
  }
  try {
    await addItemToInventory(playerId, itemId);
    showDialogue(chalk.green(`Compra realizada com sucesso! Você comprou ${item.nome}.`)); 
  } catch (error) {
    console.error('Erro ao adicionar item ao inventário:', error);
    return;
    
  }
  try {
    await updateLojaEstoque(lojaId, itemId, quantidade);
  } catch (error) {
     console.error('Erro ao atualizar estoque do item:', error);
     return;
  }
  
};
