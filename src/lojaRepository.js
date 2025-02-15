import { connect } from './db-connection.js';
import client from './db-connection.js';


export const getLojas = async () => {
  const res = await client.query("SELECT id, nome, tipo FROM Loja");
  return res.rows;
};

export const getLojaItens = async (lojaId) => {
  const res = await client.query(
    `SELECT v.id_item AS id, i.nome, v.preco, v.quantidade 
    FROM Venda v
    JOIN Item i ON v.id_item = i.id
    WHERE v.id_loja = $1`, [lojaId]);
  return res.rows;
};


export const updateLojaEstoque = async (lojaId, itemId, quantidade) => {
  try {
    return await client.query(`
        UPDATE Venda 
        SET quantidade = quantidade - $1 
        WHERE id_loja = $2 AND id_item = $3
      `, [quantidade, lojaId, itemId]);

  } catch (error) {
    console.error('Erro ao atualizar estoque da loja:', error);
    return;
  }
};


export const getLojaNaSala = async (salaId) => {
   const res = await client.query(`SELECT id, nome, tipo FROM Loja WHERE id_sala = $1`, [salaId]);
    return res.rows; 
  };