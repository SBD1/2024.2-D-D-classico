import { getLojaNaSala } from './lojaRepository.js';
import client from './db-connection.js';

const testarLoja = async () => {
    try {
        const res = await client.query('SELECT id, nome FROM Raca ORDER BY id;');
        return res.rows;
    } catch (err) {
        console.error('Erro ao buscar raças:', err);
        return [];
    }
};

testarLoja();
