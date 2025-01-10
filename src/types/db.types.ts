import type { Submittable, ClientBase } from "pg";

export type TransactionsType = {
  executeFunction: (query:ClientBase["query"]) => Promise<void>;
}

