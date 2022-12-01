// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

import "./interfaces/IValoremERC20Factory.sol";

contract ValoremERC20Factory is IValoremERC20Factory {
    struct Wrappers {
        /// @param optionWrapper The address of the ERC20 contract wrapping the options.
        address optionWrapper;
        /// @param claimWrapper The address of the ERC20 contract wrapping the claims.
        address claimWrapper;
    }

    mapping(uint160 => Wrappers) internal optionTypeToWrappers;

    address public valoremCore;

    /*//////////////////////////////////////////////////////////////
    //  Constructor
    //////////////////////////////////////////////////////////////*/

    /// @notice ValoremERC20Factory constructor
    /// @param valoremCoreOptionSettlementEngine Core contract address
    constructor(address valoremCoreOptionSettlementEngine) {
        if (valoremCoreOptionSettlementEngine == address(0x0)) {
            revert InvalidEngineAddress(valoremCoreOptionSettlementEngine);
        }
        valoremCore = valoremCoreOptionSettlementEngine;
    }

    function wrapper(uint256 tokenId) external returns (address wrapperToken) {
        revert();
    }

    /// @inheritdoc IValoremERC20Factory
    function newWrapperToken(uint160 optionId, bool option) external returns (address wrapperToken) {
        revert();
    }

    /// @inheritdoc IValoremERC20Factory
    function wrap(uint256 tokenId, address receiver, uint256 amount) external {
        revert();
    }

    /// @inheritdoc IValoremERC20Factory
    function unwrap(uint256 tokenId, address receiver, uint256 amount) external {
        revert();
    }
}
