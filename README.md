# Credit Weaver

An on-chain usage credit system for protocols built on Stacks blockchain using Clarity smart contracts.

## Overview

Credit Weaver provides a flexible framework for managing and distributing usage credits across decentralized protocols. It enables protocol owners to authorize credit issuers and allows users to earn and redeem credits.

## Features

- **Credit Management**: Track and manage user credit balances on-chain
- **Issuer Authorization**: Owner-controlled system for managing authorized credit issuers
- **Credit Awarding**: Issue credits to users (owner and authorized issuers only)
- **Credit Redemption**: Users can redeem their accrued credits
- **Balance Queries**: Read-only functions to check credit balances and redemption eligibility
- **Access Control**: Comprehensive permission checks to prevent unauthorized operations

## Contract Functions

### Owner Controls
- `add-issuer (issuer principal)` - Authorize a new credit issuer
- `remove-issuer (issuer principal)` - Revoke issuer authorization

### Credit Operations
- `award-credits (user principal) (amount uint)` - Award credits to a user
- `redeem-credits (amount uint)` - Redeem user's accrued credits

### Read-Only Helpers
- `get-credits (user principal)` - Get user's current credit balance
- `can-redeem? (user principal) (amount uint)` - Check if user can redeem amount

## Error Codes

| Code | Error | Description |
|------|-------|-------------|
| 12001 | ERR-NOT-OWNER | Caller is not the contract owner |
| 12002 | ERR-NOT-USER | Invalid user principal |
| 12003 | ERR-INSUFFICIENT | Insufficient credits or invalid amount |

## Usage

Deploy the contract and initialize authorized issuers through the owner account. Users earn credits through authorized issuers and can redeem them as needed.

## License

MIT
