// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

import "./interfaces/IValoremERC20Wrapper.sol";
import "solmate/tokens/ERC20.sol";

contract ValoremERC20Wrapper is IValoremERC20Wrapper, ERC20 {
    /// @notice The address of the valorem core option settelement contract.
    address public valoremCore;

    /*//////////////////////////////////////////////////////////////
    // constructor 
    //////////////////////////////////////////////////////////////*/

    /// @notice ValoremERC20Wrapper initializer
    /// @param valoremCoreOptionSettlementEngine Core contract address
    /// @param optionId The id of the valorem core option type.
    /// @param option True if this ERC20 is to wrap fungible ERC115s from the
    /// core contract, False if this ERC20 is to wrap nonfungible claim NFTs.
    constructor(address valoremCoreOptionSettlementEngine, uint160 optionId, bool option) ERC20("", "", 0) {
        valoremCore = valoremCoreOptionSettlementEngine;
    }

    /// @inheritdoc IValoremERC20Wrapper
    function wrap(address receiver, uint256 amount) external {
        revert();
    }

    /// @inheritdoc IValoremERC20Wrapper
    function unwrap(address receiver, uint256 amount) external {
        revert();
    }

    /// @inheritdoc IValoremERC20Wrapper
    function redeem(address receiver) external {
        revert();
    }

    /// @inheritdoc IValoremERC20Wrapper
    function exercise(address receiver, uint256 amount) external {
        revert();
    }
}
