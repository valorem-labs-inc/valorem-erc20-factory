// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.16;

import "valorem-core/src/interfaces/IOptionSettlementEngine.sol";
import "solmate/tokens/ERC1155.sol";
import "solmate/utils/SafeTransferLib.sol";

import "./interfaces/IValoremERC20Factory.sol";
import "./ValoremERC20Wrapper.sol";

contract ValoremERC20Factory is IValoremERC20Factory, ERC1155TokenReceiver {
    /// @notice A struct to store an options wrapper as well as a claim wrapper.
    struct OptionTypeWrappers {
        /// @param optionWrapper The address of the ERC20 contract wrapping the options.
        address optionWrapper;
        /// @param claimWrapper The address of the ERC20 contract wrapping the claims.
        address claimWrapper;
    }

    /// @notice The wrappers associated with a given option type id.
    mapping(uint160 => OptionTypeWrappers) internal optionTypeToWrappers;

    /// @notice The OptionSettlementEngine whose ERC1155 tokens this contract wraps.
    IOptionSettlementEngine public valoremCore;

    /*//////////////////////////////////////////////////////////////
    //  Immutable/Constant - Private
    //////////////////////////////////////////////////////////////*/

    /// @dev The bit padding for optionKey -> optionId.
    uint8 private constant OPTION_KEY_PADDING = 96;

    /// @dev The mask to mask out a claimKey from a claimId.
    uint96 private constant CLAIM_KEY_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFF;

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

    /// @inheritdoc IValoremERC20Factory
    function wrapper(uint256 tokenId) external view returns (address wrapperToken) {
        (uint160 optionKey, uint96 claimNum) = _decodeTokenId(tokenId);
        OptionTypeWrappers memory wrappers = optionTypeToWrappers[optionKey];

        if (claimNum == 0) {
            return wrappers.optionWrapper;
        }
        return wrappers.claimWrapper;
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
        ValoremERC20Wrapper _wrapper =
            new ValoremERC20Wrapper(string(name), string(symbol), address(valoremCore), optionId, option);
        address wrapperAddress = address(_wrapper);

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
        (OptionTypeWrappers storage wrappers, uint160 optionKey, uint96 claimNum) = _retrieveWrappers(tokenId, true);

        // check if these ERC1155 tokens can be wrapped

        revert();
    }

    /// @inheritdoc IValoremERC20Factory
    function unwrap(uint256 tokenId, address receiver, uint256 amount) external {
        (OptionTypeWrappers storage wrappers, uint160 optionKey, uint96 claimNum) = _retrieveWrappers(tokenId, true);

        // check if these ERC1155 tokens can be unwrapped

        revert();
    }

    /**
     * @notice Decodes the supplied token id
     * @dev See tokenType() for encoding scheme
     * @param tokenId The token id to decode
     * @return optionKey claimNum The decoded components of the id as described above, padded as required
     */
    function _decodeTokenId(uint256 tokenId) private pure returns (uint160 optionKey, uint96 claimNum) {
        // Move option key to lsb to fit into uint160.
        optionKey = uint160(tokenId >> OPTION_KEY_PADDING);

        // Get lower 96b of tokenId for uint96 claim key.
        claimNum = uint96(tokenId & CLAIM_KEY_MASK);
    }

    function _retrieveWrappers(uint256 tokenId, bool check)
        internal
        view
        returns (OptionTypeWrappers storage wrappers, uint160 optionKey, uint96 claimNum)
    {
        (optionKey, claimNum) = _decodeTokenId(tokenId);

        wrappers = optionTypeToWrappers[optionKey];

        if (check && claimNum == 0 && wrappers.optionWrapper == address(0)) {
            revert WrapperDoesNotExist(optionKey, true);
        }

        if (check && claimNum != 0 && wrappers.claimWrapper == address(0)) {
            revert WrapperDoesNotExist(optionKey, false);
        }
    }
}
