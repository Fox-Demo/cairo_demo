# Cairo ERC721 Repo

## How to build / test ?

Pre-requisites:

1. Install [Scarb](https://docs.swmansion.com/scarb/)
2. Install [snforge](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html)

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

In this case, use Starkli to create account and import account into sncast

Ref: [Starknet Foundry: Creating And Deploying Accounts](https://foundry-rs.github.io/starknet-foundry/starknet/account.html)

Pre-requisites:

1. Install Starkli and [create / deploy account](https://docs.starknet.io/quick-start/set-up-an-account/#creating_an_account)

### Declare contract (sepolia)

According to the official documentation, `~/.starkli-wallets/deployer/` is the default keystore / account path.

```bash
sncast \
--url https://free-rpc.nethermind.io/sepolia-juno \
--keystore ~/.starkli-wallets/deployer/keystore.json \
--account ~/.starkli-wallets/deployer/account.json \
declare \
--contract-name ERC721
```

### Deploy

```bash
sncast \
--url https://free-rpc.nethermind.io/sepolia-juno \
--keystore ~/.starkli-wallets/deployer/keystore.json \
--account ~/.starkli-wallets/deployer/account.json \
deploy\
--class-hash <class_hash generated from previous `declare` command> \
--constructor-calldata <serialized constructor calldata (felt252 e.g. 0x42 0x41)>
```

# Note

- Only Nethermind's RPC is available (correct version)
- `~/.starknet_accounts/starknet_open_zeppelin_accounts.json` is sncast create account by default
