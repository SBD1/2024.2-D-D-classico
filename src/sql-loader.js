import fs from "fs";
import client, { transactions } from "./db-connection.js";
import { clearNLines, createProgressBar, sleep } from "./utils.js";
import chalk from "chalk";

const ddlPath = 'src/sql/DDL.sql';
const dmlPath = 'src/sql/DML.sql';
const tablesRequired = new Set(["regiao","salas","caminhos","personagem"])

export const createDBTables = async () => {
  let progressBar;
  try {

    const ddl = fs.readFileSync(ddlPath, 'utf8');
    const commands = removeCommentsPipe(ddl);
    console.log();
    progressBar = createProgressBar(commands.length,50);
    await transactions(async (poolClient) =>{
      for (const command of commands) {
        await sleep()
        await poolClient.query(command);
        progressBar.increment(1)
      }
    })
    clearNLines();
    console.log(chalk.green("Tabelas criadas!"));
    

  } catch (error) {
    progressBar?.showError();
    console.error("Falha ao rodar as migrações no DDL");
    console.log(error);
    process.exit(1);
  }
}

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

export const needCreateTable = async () => {
  
  const { rows, rowCount } = await client.query(`SELECT tablename
    FROM pg_catalog.pg_tables
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
    where schemaname = 'public'
    ORDER BY schemaname, tablename `);
  if (rowCount !== tablesRequired.size) {
    return true;
  }
  const result = new Set(rows.map(i=>i.tablename));
  return result.intersection(tablesRequired).size !== tablesRequired.size;
}

export const needSeedTable = async () => {
  const {rowCount} = await client.query(`SELECT r.id FROM regiao r where id in (1,2)`);
  if (rowCount < 2) {
    return true;
  }
  const {rowCount: salaCount} = await client.query(`SELECT s.id FROM salas s where id in (1,2,3,4)`);
  if (salaCount < 4) {
    return true;
  }

  const {rowCount: caminhoCount} = await client.query(`SELECT c.id FROM caminhos c where id in (1,2,3,4,5,6)`);
  if (caminhoCount < 6) {
    return true;
  }
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
