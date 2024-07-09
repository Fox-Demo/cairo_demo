use starknet::ContractAddress;

// declare interface to `pub` (used by test)
#[starknet::interface]
pub trait IERC721<TContractState> {
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn token_uri(self: @TContractState, token_id: u256) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn is_approved_for_all(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;

    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;

    fn set_approval_for_all(ref self: TContractState, operator: ContractAddress, approved: bool);
    fn approve(ref self: TContractState, to: ContractAddress, token_id: u256);
    fn transfer_from(
        ref self: TContractState, from: ContractAddress, to: ContractAddress, token_id: u256
    );
    fn mint(ref self: TContractState, recipient: ContractAddress, token_id: u256);
}

#[starknet::contract]
mod ERC721 {
    use core::traits::Into;
    use core::zeroable;

    use super::IERC721;

    use starknet::ContractAddress;
    use starknet::get_caller_address;


    //Create a storage variable
    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        owners: LegacyMap::<u256, ContractAddress>,
        balances: LegacyMap::<ContractAddress, u256>,
        token_approvals: LegacyMap::<u256, ContractAddress>,
        operator_approvals: LegacyMap::<(ContractAddress, ContractAddress), bool>,
        token_uri: LegacyMap::<u256, felt252>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, _name: felt252, symbol: felt252) {
        self.name.write(_name);
        self.symbol.write(symbol);
    }

    #[abi(embed_v0)]
    impl ERC721Impl of super::IERC721<ContractState> {
        fn get_name(self: @ContractState) -> felt252 {
            self.name.read()
        }

        fn get_symbol(self: @ContractState) -> felt252 {
            self.symbol.read()
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            self.balances.read(account)
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self.operator_approvals.read((owner, operator))
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            self.owners.read(token_id)
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            self.token_approvals.read(token_id)
        }

        fn token_uri(self: @ContractState, token_id: u256) -> felt252 {
            self.token_uri.read(token_id)
        }

        // Write Functions

        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            let caller = get_caller_address();
            self.operator_approvals.write((caller, operator), approved);
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            //TODO assert to and caller / owner
            self.token_approvals.write(token_id, to);
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            self.is_approved_for_all(from, get_caller_address()); // auth approve
            self.owners.write(token_id, to);
        }

        fn mint(ref self: ContractState, recipient: ContractAddress, token_id: u256) {
            self.owners.write(token_id, recipient);
            self.token_uri.write(token_id, 'tokenuri');
            self.balances.write(recipient, self.balances.read(recipient) + 1);
        }
    }

    #[external(v0)]
    fn safe_transfer_from(
        ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
    ) {
        self.transfer_from(from, to, token_id); // Auto input self (don't explict it)
    }
}

