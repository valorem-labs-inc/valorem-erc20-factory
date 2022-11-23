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
    /*//////////////////////////////////////////////////////////////
    //  Events
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Emitted when a new ERC20 wrapper is created for a given Valorem core
     * ERC1155 token.
     * @param tokenId The ERC1155 token ID.
     * @param wrapperAddress The address of the wrapper erc20 contract. 
     */
    event NewValoremWrapper(uint256 indexed tokenId, address indexed wrapperAddress);

    /**
     * @notice Emitted when Valorem core ERC1155 tokens are wrapped in an ERC20 wrapper.
     * @param tokenId The ERC1155 token ID to wrap.
     * @param wrapperAddress The address of the wrapping ERC20 contract.
     * @param amount The amount of tokens to wrap.
     */
    event TokensWrapped(uint256 indexed tokenId, address indexed wrapperAddress, uint256 amount);

    /*//////////////////////////////////////////////////////////////
    //  Data structures 
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
    //  Accessors
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
    //  Protocol Admin
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
    //  Wrap and unwrap
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Deploy a new wrapper ERC20 contract for a given token ID
     * @return The wrapper ERC20 address.
     */
    function newWrapperContract() external returns (address); 

    /**
     * @notice Wraps a semifungible valorem core option type or claim in a new ERC20
     * contract.
     * @param tokenId The token or claim ID.
     */
    function wrapCoreTokens(uint256 tokenId) external;

    /**
     * @notice Unwraps a semifungible valorem core option type or claim 
     * @param tokenId The token or claim ID.
     */
    function unwrapCoreTokens(uint256 tokenId) external;
}