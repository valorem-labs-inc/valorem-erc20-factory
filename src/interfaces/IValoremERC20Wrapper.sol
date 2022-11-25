// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

/**
 * A wrapper around Valorem core ERC1155 tokens (options and claims).
 *
 * When wrapping a Valorem core ERC1155 NFT (i.e. an options lot claim) shares of the lot
 * will be minted in the amount of the number of options in that lot. That is, the balances
 * of the resulting ERC20 contract will represent fractionalized shares of the claim lot.
 *
 * When wrapping a Valorem core ERC1155 semifungible token (i.e. written options contracts)
 * ERC20 tokens will be minted in a 1:1 ratio with those ERC1155 tokens being wrapped.
 *
 * Users with balance can choose to redeem their fractionalized options lot shares 
 * after expiry of the Valore core option type, or exercise their options after the exercise
 * timestamp of the option type (and before expiry).
 *
 * Implementations of this interface should also implement IERC1155 receiver and IERC20
 */
interface IValoremERC20Wrapper {
    /**
     * @notice Wraps the specified amount of ERC1155 tokens and sends to specified account.
     * @param _account The account to which ERC20 tokens will be minted.
     * @param _amount Amount of tokens to be wrapped. 
     */
    function wrap(address _account, uint256 _amount) external;
    
    /**
     * @notice Unwraps the specified amount of ERC1155 tokens and sends to specified account.
     * @param _account The account to which ERC20 tokens will be minted.
     * @param _amount Amount of tokens to be wrapped. 
     */
    function unwrap(address _account, uint256 _amount) external;

    /**
     * @notice Redeems an account's fractionalized share of an options lot for the underlying
     * and exercise assets. Reverts if this contract wraps semifungible options contracts rather
     * than an options lot claim NFT.
     * @param _account The account for which the ERC20 balance is being redeemed.
     */
    function redeem(address _account) external;

    /**
     * @notice Exercises the options associated with the supplied account in the amount specified.
     * Reverts if this contract wraps an options lot claim NFT rather than semifungible options contracts.
     * @param _account The account exercising the options contracts.
     * @param _amount The amount to exercise.
     */
    function exercise(address _account, uint256 _amount) external;
}