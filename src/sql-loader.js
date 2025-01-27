import fs from "fs";
import client, {transactions} from "./db-connection.js";
import { clearNLines, createProgressBar, sleep } from "./utils.js";
import chalk from "chalk";

const dmlPath = 'src/sql/DML.sql';

export const seedDBTables = async () => {
  let progressBar;
  try {
    const dml = fs.readFileSync(dmlPath, 'utf8');
    const commands = removeCommentsPipe(dml).filter(i=>i.includes("INSERT INTO"));
    console.log();
    progressBar = createProgressBar(commands.length,50);
    
    
    await transactions(async (poolClient) =>{
      for (const command of commands) {                
        await sleep(500);
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
  await client.connect()
  const {rows} = await client.query(`SELECT * FROM regiao r where id = $1 or id = $2`,[1,2]);
  if (rows.length < 2) {
    return true;
  }

  const {rowCount: salaCount} = await client.query(`SELECT s.id FROM salas s where id in (1,2,3,4)`);
  if (salaCount < 4) {
    return true;
  }
  return false;
}

const removeCommentsPipe = (rawFile) => {
  const onlyValidsLines = rawFile.split('\n').filter(line => commentAndNewlineFilter(line)).map(i => i.trim());
  const removedStrangeComents = onlyValidsLines.map(i=>i.split("--")[0]);
  const sqlStatements = removedStrangeComents.join("").split(';').filter(i=>i)
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
