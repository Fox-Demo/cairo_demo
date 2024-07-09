use snforge_std::{declare, ContractClassTrait, start_cheat_caller_address};
use starknet::ContractAddress;
use core::serde::Serde;

use openzeppelin::token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};

fn deploy_contract(
    total_supply: u256, receipt: ContractAddress
) -> (ERC20ABIDispatcher, ContractAddress) {
    let contract = declare("OZToken").unwrap();

    // Build constructor arguments call data
    let mut call_data: Array<felt252> = ArrayTrait::new();

    Serde::serialize(@total_supply, ref call_data);
    Serde::serialize(@receipt, ref call_data);

    let (contract_address, _) = contract.deploy(@call_data).unwrap();

    (ERC20ABIDispatcher { contract_address }, contract_address)
}

#[test]
fn check_total_supply() {
    let total_supply: u256 = 1000;
    let receipt: ContractAddress = 123.try_into().unwrap();
    let (contract, _) = deploy_contract(total_supply, receipt);

    assert(contract.total_supply() == total_supply, 'Invalid total supply');
}
