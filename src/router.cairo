use starknet::ContractAddress;

#[starknet::interface]
trait IRouter<TContractState, TContractStorage> {
    fn mint(self: @TContractState, recipient: ContractAddress, token_id: u256);
}

#[starknet::contract]
mod Router {
    use starknet::ContractAddress;
    use super::IRouter;

    #[abi(embed_v0)]
    impl RouterImpl of IRouter<ContractState> {
        fn mint(self: @ContractState, recipient: ContractAddress, token_id: u256) {
            // Implementation of the mint function
        }
    }
}

