import fs from "fs";
import client from "./db-connection.js";
import { clearNLines, createProgressBar, sleep } from "./utils.js";
import chalk from "chalk";

const dmlPath = 'src/sql/DML.sql';

export const seedDBTables = async () => {
  let progressBar;
  try {
    const dml = fs.readFileSync(dmlPath, 'utf8');
    const commands = removeCommentsPipe(dml).filter(i=>!i.includes("UPDATE"));
    console.log();
    progressBar = createProgressBar(commands.length,50);
    
    
    await transactions(async (poolClient) =>{
      for (const command of commands) {
        await sleep()
        await poolClient.query(command);
        progressBar.increment(1);
      }
    })
    clearNLines();
    console.log(chalk.green("Tabelas populadas!"));
  } catch (error) {
    progressBar?.showError();
    console.error("Falha ao rodar as migrações no DDL");
    console.log(error);
    process.exit(1);
  }
}

export const needSeedTable = async () => {
  console.log(1);
  await client.connect()
  const {rows} = await client.query(`SELECT * FROM regiao r where id = $1 or id = $2`,[1,2]);
  console.log(2);
  if (rows.length < 2) {
    return true;
  }

  const {rowCount: salaCount} = await client.query(`SELECT s.id FROM salas s where id in (1,2,3,4)`);
  console.log(3);
  if (salaCount < 4) {
    return true;
  }

  const {rowCount: caminhoCount} = await client.query(`SELECT c.id FROM caminhos c where id in (1,2,3,4,5,6)`);
  console.log(4);

  if (caminhoCount < 6) {
    return true;
  }
  console.log(5);

  return false;
}

const removeCommentsPipe = (rawFile) => {
  const onlyValidsLines = rawFile.split('\n').filter(line => commentAndNewlineFilter(line)).map(i => i.trim());
  const sqlStatements = onlyValidsLines.join("").split(';').filter(i=>i)
  return sqlStatements;
}

const commentAndNewlineFilter = (str) => {
  if (
    (!str || str.length === 0) ||
    (str[0]==='-' && str[1] === '-') ||
    (str[0]==='\n')
  ) {
    return false;
  }
  return true;
}
