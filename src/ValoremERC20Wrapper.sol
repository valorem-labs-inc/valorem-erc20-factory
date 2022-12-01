// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

import "./interfaces/IValoremERC20Wrapper.sol";

contract ValoremERC20Wrapper is IValoremERC20Wrapper {
    /// @notice The address of the valorem core option settelement contract.
    address public valoremCore;

    
    /*//////////////////////////////////////////////////////////////
    //  Constructor
    //////////////////////////////////////////////////////////////*/

    /// @notice ValoremERC20Factory constructor
    /// @param valoremCoreOptionSettlementEngine Core contract address
    constructor(
        address valoremCoreOptionSettlementEngine,
        uint160 optionId, 
        bool option) 
    {
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