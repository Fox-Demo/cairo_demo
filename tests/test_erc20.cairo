use snforge_std::{declare, ContractClassTrait, start_cheat_caller_address};
use starknet::ContractAddress;
use core::serde::Serde;

//use openzeppelin::token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
use starknet_nft::ERC20::{IERC20Dispatcher, IERC20DispatcherTrait};


fn deploy_contract(
    total_supply: u256, receipt: ContractAddress
) -> (IERC20Dispatcher, ContractAddress) {
    let contract = declare("ERC20").unwrap();

    // Build constructor arguments call data
    let mut call_data: Array<felt252> = ArrayTrait::new();

    Serde::serialize(@total_supply, ref call_data);
    Serde::serialize(@receipt, ref call_data);

    let (contract_address, _) = contract.deploy(@call_data).unwrap();

    (IERC20Dispatcher { contract_address }, contract_address)
}

#[test]
fn check_total_supply() {
    let total_supply: u256 = 1000;
    let receipt: ContractAddress = 123.try_into().unwrap();
    let (contract, _) = deploy_contract(total_supply, receipt);

    assert(contract.total_supply() == total_supply, 'Invalid total supply');
}

#[test]
fn test_mint() {
    let total_supply: u256 = 1000;
    let receipt: ContractAddress = 123.try_into().unwrap();
    let (contract, contract_address) = deploy_contract(total_supply, receipt);

    start_cheat_caller_address(contract_address, receipt);
    contract.mint(100);
    assert(contract.balance_of(receipt) == 1100, 'Invalid balance');
}

