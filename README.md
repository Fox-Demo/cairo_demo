# Cairo ERC721 Repo

## How to build / test ?

Pre-requisites:

1. Install Scarb
2. Install snforge

### Build contract

```bash
scarb build
```

### Test

```bash
snforge test
```

# Deploy

Two method to create account:

1. starkli
2. sncast account create

Pre-requisites:

1. Install starkli

# Note

- Only Nethermind's RPC is available (correct version)
- ~/.starknet_accounts/starknet_open_zeppelin_accounts.json is sncast create account by default
