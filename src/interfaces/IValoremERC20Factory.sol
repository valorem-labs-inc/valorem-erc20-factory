// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.16;

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
     * @param optionId The option type id in the core valorem contract.
     * @param wrapperAddress The address of the wrapper erc20 contract.
     * @param option True if the wrapper wraps an option type, false if it wraps claims.
     */
    event NewValoremWrapper(uint160 indexed optionId, address indexed wrapperAddress, bool option);

    /**
     * @notice Emitted when Valorem core ERC1155 tokens are wrapped in an ERC20 wrapper.
     * @param optionId The option type id in the core valorem contract.
     * @param wrapperAddress The address of the wrapping ERC20 contract.
     * @param amount The amount of tokens to wrap.
     */
    event TokensWrapped(uint160 indexed optionId, address indexed wrapperAddress, uint256 amount);

    /*//////////////////////////////////////////////////////////////
    //  Errors
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice The supplied option settelement engine address to the factory is invalid.
     * @param engineAddress The invalid address.
     */
    error InvalidEngineAddress(address engineAddress);

    /**
     * @notice The supplied optionId cannot be wrapped because it is past expiry or
     * past the exercise timestamp.
     * @param optionId The optionId which cannot be wrapped.
     */
    error InvalidOptionToWrap(uint160 optionId, uint40 exerciseTimestamp);

    /**
     * @notice The requested option id type to wrap already has an existing wrapper.
     * @param optionId The optionId which has already been wrapped.
     * @param wrapperToken The contract address of the existing ERC20 wrapper.
     */
    error WrapperAlreadyExists(uint160 optionId, address wrapperToken);

    /*//////////////////////////////////////////////////////////////
    //  Data structures 
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
    //  Accessors
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Retrieves the wrapper ERC20 contract address for a supplied Valorem core token ID.
     * @param tokenId The token ID for which to retrieve the wrapper.
     * @return wrapperToken The address of the ERC20 wrapper contract.
     */
    function wrapper(uint256 tokenId) external view returns (address wrapperToken);

    /*//////////////////////////////////////////////////////////////
    //  Protocol Admin
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
    //  Wrap and unwrap
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Deploy a new ERC20 wrapper for a given Valorem ERC1155 token ID. Reverts
     * if there is an existing contract for the given token ID. Reverts if the given token ID does
     * not correspond to an existing option type in the Valorem Core contract.
     * @param optionId The Valorem core option ID for which to deploy a wrapper. Corresponds to an
     * option type in the core contract.
     * @param option True if the new wrapper should wrap options contracts in an ERC20 wrapper. False
     * if this new wrapper should wrap claims to underlying options lots.
     * @return wrapperToken The wrapper ERC20 address.
     */
    function newWrapperToken(uint160 optionId, bool option) external returns (address wrapperToken);

    /**
     * @notice Wraps a semifungible Valorem core option type or claim in a new ERC20
     * contract.
     * @param tokenId The token or claim ID.
     * @param receiver The recipient of the newly wrapped ERC20 tokens.
     * @param amount The amount of the specified token ID to wrap.
     */
    function wrap(uint256 tokenId, address receiver, uint256 amount) external;

    /**
     * @notice Unwraps a semifungible Valorem core option type or claim.
     * @param tokenId The token or claim ID.
     * @param receiver The recipient of the unwrapped ERC1155 tokens.
     * @param amount The amount of the specified token ID to unwrap.
     */
    function unwrap(uint256 tokenId, address receiver, uint256 amount) external;
}
