// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

/**
 * This defines the interface for an ERC20 wrapper factory for Valorem Core nonfungible and 
 * semifungible ERC1155 tokens, see https://github.com/valorem-labs-inc/valorem-core/blob/master/README.md
 * 
 * The core represents options contracts as semifungible ERC1155 tokens. When writing an option of a 
 * particular type, the writing address is transferred the same amount of tokens as options being written,
 * with the token ID corresponding to the option ID. The writer transfers in an appropriate amount of 
 * collateral, to be collected by an options holder in the event they choose to exercise the option.
 * 
 * The writer is then free to sell and trade these ERC1155 balances as they see fit. To represent their
 * claim over the collateral transferred in as part of writing options as well as their claim over the
 * assets transferred in by options holders upon exercise, an option writer is minted a nonfungible 
 * ERC1155 representing a claim over a given lot of options they've written. After option expiry, they
 * can come back and claim their share of the exercised and unexercised assets.
 * 
 * This interface defines a contract which wraps each of these (both the semifungible and nonfungible 
 * ERC115 tokens) in new solmate ERC20 token contracts to make them suitable for trade on e.g. Uniswap.
 */
interface IValoremERC20Factory {
    
}