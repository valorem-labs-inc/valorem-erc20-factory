// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

import "valorem-core/src/interfaces/IOptionSettlementEngine.sol";

import "./interfaces/IValoremERC20Factory.sol";
import "./ValoremERC20Wrapper.sol";

contract ValoremERC20Factory is IValoremERC20Factory {
    struct OptionTypeWrappers {
        /// @param optionWrapper The address of the ERC20 contract wrapping the options.
        address optionWrapper;
        /// @param claimWrapper The address of the ERC20 contract wrapping the claims.
        address claimWrapper;
    }

    mapping(uint160 => OptionTypeWrappers) internal optionTypeToWrappers;

    IOptionSettlementEngine public valoremCore;

    /*//////////////////////////////////////////////////////////////
    //  Constructor
    //////////////////////////////////////////////////////////////*/

    /// @notice ValoremERC20Factory constructor
    /// @param valoremCoreOptionSettlementEngine Core contract address
    constructor(address valoremCoreOptionSettlementEngine) {
        if (valoremCoreOptionSettlementEngine == address(0x0)) {
            revert InvalidEngineAddress(valoremCoreOptionSettlementEngine);
        }
        // TODO: verify that this is an engine
        // TODO: expose admin setter
        valoremCore = IOptionSettlementEngine(valoremCoreOptionSettlementEngine);
    }

    function wrapper(uint256 tokenId) external returns (address wrapperToken) {
        revert();
    }

    /// @inheritdoc IValoremERC20Factory
    function newWrapperToken(uint160 optionId, bool option) external returns (address wrapperToken) {
        // revert if a wrapper already exists for this option type
        OptionTypeWrappers storage wrappers = optionTypeToWrappers[optionId];
        if (option && wrappers.optionWrapper != address(0)) {
            revert WrapperAlreadyExists(optionId, wrappers.optionWrapper);
        }

        if (!option && wrappers.claimWrapper != address(0)) {
            revert WrapperAlreadyExists(optionId, wrappers.claimWrapper);
        }

        // retrieve and validate option type from core
        IOptionSettlementEngine.Option memory optionType = valoremCore.option((uint256(optionId) << 96));

        // revert if option is not initialized
        if (optionType.underlyingAsset == address(0)) {
            revert OptionTypeNotInitialized(optionId);
        }

        // revert if option is after exercise timestamp
        if (block.timestamp >= optionType.exerciseTimestamp) {
            revert InvalidOptionToWrap(optionId, optionType.exerciseTimestamp);
        }

        ERC20 underlying = ERC20(optionType.underlyingAsset);
        ERC20 exercise = ERC20(optionType.exerciseAsset);

        bytes memory name;
        bytes memory symbol;

        // generate name, symbol
        if (option) {
            name = abi.encodePacked("Valorem ", exercise.name, " -> ", underlying.name, " option");
            symbol = abi.encodePacked(exercise.symbol, ">", underlying.symbol);
        } else {
            name = abi.encodePacked("Valorem ", exercise.name, "->", underlying.name, " option lot claim");
            symbol = abi.encodePacked(exercise.symbol, "&", underlying.symbol);
        }

        // deploy new wrapper
        ValoremERC20Wrapper wrapper = new ValoremERC20Wrapper(string(name), string(symbol), address(valoremCore), optionId, option);
        address wrapperAddress = address(wrapper);

        if (option) {
            wrappers.optionWrapper = wrapperAddress;
        } else {
            wrappers.claimWrapper = wrapperAddress;
        }

        emit NewValoremWrapper(optionId, wrapperAddress, option);

        return wrapperAddress;
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
