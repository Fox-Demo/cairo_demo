use core::traits::Into;
use core::option::OptionTrait;
use core::traits::TryInto;
use snforge_std::{declare, ContractClassTrait, start_cheat_caller_address};
use starknet_nft::IERC721DispatcherTrait;
use starknet_nft::IERC721Dispatcher;
use starknet::ContractAddress;

use core::serde::Serde;

fn deploy_contract(name: @felt252, symbol: @felt252) -> (IERC721Dispatcher, ContractAddress) {
    let contract = declare("ERC721").unwrap();

    // Build constructor arguments call data
    let mut call_data: Array<felt252> = ArrayTrait::new();

    Serde::serialize(name, ref call_data);
    Serde::serialize(symbol, ref call_data);

    let (contract_address, _) = contract.deploy(@call_data).unwrap();

    (IERC721Dispatcher { contract_address }, contract_address)
}

#[test]
fn check_name_symbol() {
    let name = 'Token';
    let symbol = 'Token_Symbol';

    let (erc721, _) = deploy_contract(@name, @symbol);

    assert(erc721.get_name() == name, 'Invalid name');
    assert(erc721.get_symbol() == symbol, 'Invalid symbol');
}


#[test]
fn mint_token() {
    let name = 'Token';
    let symbol = 'Token_Symbol';
    let user: ContractAddress = 123.try_into().unwrap();

    let (erc721, contract_address) = deploy_contract(@name, @symbol);
    start_cheat_caller_address(contract_address, user);

    erc721.mint(user, 1);

    assert(erc721.balance_of(user) == 1, 'Invalid balance');
    assert(erc721.owner_of(1) == user, 'Invalid owner');
}

