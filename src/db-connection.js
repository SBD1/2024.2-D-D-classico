import pg from 'pg'
import 'dotenv/config'
import chalk from 'chalk';
import { clearNLines } from './utils.js';

const { Client, Pool } = pg;

let client = new Client({
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  port: +(process.env.DB_PORT ?? 5432),
  user: process.env.DB_USER,
  query_timeout:5000,
  password: process.env.DB_PASSWORD
})

const poolConection = new Pool({
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  port: +(process.env.DB_PORT ?? 5432),
  user: process.env.DB_USER,
  query_timeout:5000,
  password: process.env.DB_PASSWORD
});

client.on('end', () => {
  console.log("Conexão terminada com sucesso");
  process.exit(0);
});

client.on('error', (err) => {
  console.error("Ocorreu um erro com a conexão do banco:", err);
  process.exit(1);
})

const retryConnection = async () => {
  let currentTry = 0;
  let numberTries = 3;
  let waitTime = 1000;
  while (currentTry < numberTries) {
    try {
      client = new Client({
        host: process.env.DB_HOST,
        database: process.env.DB_DATABASE,
        port: +(process.env.DB_PORT ?? 5432),
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD
      });
      console.warn(`Tentando conectar com banco de dados ${currentTry + 1}`);
      await client.connect()
      clearNLines();
      console.log(chalk.green("Conexão sucedida"));

      break;
    } catch (error) {
      currentTry++;
      if (currentTry >= numberTries) {
        throw error;
      }
      console.error(`Falha ao conectar com o banco de dados! Tentando de novo em ${waitTime / 1000}s`);
      console.log("Erro apresentado na conexão - ",error);
      await new Promise(resolve => setTimeout(resolve, waitTime));
    }
  }
}

export const connect = async () => {
  try {
    await retryConnection()
  } catch {
    console.error("Falha ao conectar com o banco de dados!");
    console.warn("Erros comuns:");
    console.warn("- banco postgres indisponível");
    console.warn("- arquivo .env não se encontra na mesma pasta que o package.json");
    console.warn("- dados dentro do .env não corretos");
    process.exit(1);
  }
}

export const transactions = async (executeFunction) => {

  const poolClient = await poolConection.connect();

  try {
    await poolClient.query('BEGIN')    
    await executeFunction(poolClient);
    await poolClient.query('COMMIT')
  } catch (e) {
    await poolClient.query('ROLLBACK')
    throw e
  } finally {
    poolClient.release();
  }
}


export default client