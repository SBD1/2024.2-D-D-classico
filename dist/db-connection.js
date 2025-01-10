"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var _a, _b;
Object.defineProperty(exports, "__esModule", { value: true });
exports.transactions = exports.connect = void 0;
const pg_1 = require("pg");
require("dotenv/config");
let client = new pg_1.Client({
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    port: +((_a = process.env.DB_PORT) !== null && _a !== void 0 ? _a : 5432),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
});
const poolConection = new pg_1.Pool({
    host: process.env.DB_HOST,
    database: process.env.DB_DATABASE,
    port: +((_b = process.env.DB_PORT) !== null && _b !== void 0 ? _b : 5432),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
});
client.on('end', () => {
    console.log("Conexão terminada com sucesso");
    process.exit(0);
});
client.on('error', (err) => {
    console.error("Ocorreu um erro com a conexão do banco:", err);
    process.exit(1);
});
const retryConnection = () => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    let currentTry = 0;
    let numberTries = 3;
    let waitTime = 1000;
    while (currentTry < numberTries) {
        try {
            client = new pg_1.Client({
                host: process.env.DB_HOST,
                database: process.env.DB_DATABASE,
                port: +((_a = process.env.DB_PORT) !== null && _a !== void 0 ? _a : 5432),
                user: process.env.DB_USER,
                password: process.env.DB_PASSWORD
            });
            console.warn(`Tentando conectar com banco de dados ${currentTry + 1}`);
            yield client.connect();
        }
        catch (error) {
            currentTry++;
            if (currentTry >= numberTries) {
                throw error;
            }
            console.error(`Falha ao conectar com o banco de dados! Tentando de novo em ${waitTime / 1000}s`);
            console.log("Erro apresentado na conexão - ", error);
            yield new Promise(resolve => setTimeout(resolve, waitTime));
        }
    }
});
const connect = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        yield retryConnection();
    }
    catch (_a) {
        console.error("Falha ao conectar com o banco de dados!");
        console.warn("Erros comuns:");
        console.warn("- banco postgres indisponível");
        console.warn("- arquivo .env não se encontra na mesma pasta que o package.json");
        console.warn("- dados dentro do .env não corretos");
        process.exit(1);
    }
});
exports.connect = connect;
const transactions = (executeFunction) => __awaiter(void 0, void 0, void 0, function* () {
    const poolClient = yield poolConection.connect();
    try {
        yield poolClient.query('BEGIN');
        yield executeFunction(poolClient.query);
        yield poolClient.query('COMMIT');
    }
    catch (e) {
        yield poolClient.query('ROLLBACK');
        throw e;
    }
    finally {
        poolClient.release();
    }
});
exports.transactions = transactions;
exports.default = client;
//# sourceMappingURL=db-connection.js.map