# CryptoScope

A Clarity smart contract system for monitoring and tracking on-chain activity on the Stacks blockchain.

## Features
- Track wallet activity and transactions
- Monitor specific addresses
- Store historical transaction data
- Query transaction history and stats
- Paginated transaction history queries

## Contract Functions
- `add-tracked-address`: Add an address to monitor
- `remove-tracked-address`: Remove an address from monitoring
- `log-transaction`: Log transaction details for tracked addresses
- `get-transaction`: Get a specific transaction by ID
- `get-transactions-page`: Get paginated transaction history for an address
- `get-stats`: Get statistics for tracked addresses

## Usage
### Querying Transaction History
To retrieve transaction history for an address, use the `get-transactions-page` function:
```clarity
(get-transactions-page address page-number)
```
Each page contains up to 50 transactions, sorted by transaction ID.

[Additional usage examples and deployment instructions]
