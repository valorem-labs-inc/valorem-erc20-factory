# Valorem ERC20 Adapter

An ERC20 factory contract which generates adapters for Valorem Core ERC1155 
tokens. This allows userns adapt Valorem Core 1155 options and claims into 
long and short fungible ERC20 tokens positions, so that they can transact 
using them within the DeFi ecosystem components supporting ERC20 tokens.

## Contracts

### ERC20Factory

### ERC20LongAdapter

#### `wrap`

When wrapping an amount of fungible Valore Core Options, the user will call `ValoremERC20Wrapper.wrap`, specifying the intendend recipient of the wrapped tokens, and the amount of Valorem Core Options to wrap. An according amount of fungible ERC1155 tokens will be transfered to the `ValoremERC20Wrapper` contract, and the `ValoremERC20Wrapper` will mint the specified recipient a commensurate amount of ERC20 tokens.

Valorem Core Options may only be wrapped in this way if the corresponding option type in the Valorem Core contract is not in its exercise window.

#### `unwrap`

When unwrapping an amount of fungible Valorem Core Options, the user will call `ValoremERC20Wrapper.unwrap`, specifying the intended recipient of the unwrapped tokens, and the amount of Valorem Core Options to unwrap. An according amount of fungible ERC20 tokens will be burned, and the `ValoremERC20Wrapper` will transfer the specified amount of fungible ERC1155 tokens to the specified recipient.

Valorem Core Options may only be unwrapped in this way if the corresponding option type in the Valorem Core contract is not in its exercise window.

#### `exercise`

The ERC20 balances are minted 1:1 with the amount of Valorem Core Options transferred in to the contract via `wrap`.

If the corresponding option type is in its exercise period, the user is able to exercise any amount of their ERC20 balance (corresponding to an ERC1155 balance in the same amount held by the wrapper contract) by calling `ValoremERC20Wrapper.exercise`. This will:

1) Transfer in an appropriate amount of the exercise asset from the caller into the `ValoremERC20Wrapper` contract.
2) Call `exercise` on the Valorem Core contract.
3) Transfer out an appropriate amount of the underlying asset from the `ValoremERC20Wrapper` contract to the caller
4) Burn an ERC20 balance in the `ValoremERC20Wrapper` belonging to the caller in the amount specified in the call to `ValoremERC20Wrapper.exercise`

This allows a caller to exercise their ERC20 options in much the same way they would exercise their ERC1155 balance in the Valorem Core contract.

### ERC20ShortAdapter