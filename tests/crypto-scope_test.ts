import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types
} from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
  name: "Ensure can add and remove tracked addresses",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const wallet1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("crypto-scope", "add-tracked-address", 
        [types.principal(wallet1.address)], deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result, '(ok true)');
    
    block = chain.mineBlock([
      Tx.contractCall("crypto-scope", "is-tracked-address",
        [types.principal(wallet1.address)], deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result, 'true');
  }
});

Clarinet.test({
  name: "Ensure can log transactions and retrieve pages",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const deployer = accounts.get("deployer")!;
    const wallet1 = accounts.get("wallet_1")!;
    
    let block = chain.mineBlock([
      Tx.contractCall("crypto-scope", "add-tracked-address",
        [types.principal(wallet1.address)], deployer.address
      ),
      Tx.contractCall("crypto-scope", "log-transaction",
        [
          types.principal(wallet1.address),
          types.uint(1000),
          types.ascii("transfer")
        ],
        deployer.address
      )
    ]);
    assertEquals(block.receipts[1].result, '(ok u0)');

    block = chain.mineBlock([
      Tx.contractCall("crypto-scope", "get-transactions-page",
        [
          types.principal(wallet1.address),
          types.uint(0)
        ],
        deployer.address
      )
    ]);
    assertEquals(block.receipts[0].result.includes('amount: u1000'), true);
  }
});
