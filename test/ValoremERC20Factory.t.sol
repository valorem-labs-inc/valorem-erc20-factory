// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import "valorem-core/src/OptionSettlementEngine.sol";
import "valorem-core/test/OptionSettlementEngine.t.sol";

import "../src/ValoremERC20Factory.sol";

contract ValoremERC20FactoryTest is Test {
    using stdStorage for StdStorage;

    // Tokens
    address public constant WETH_A = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant DAI_A = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant USDC_A = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    // Users
    address public constant ALICE = address(0xA);
    address public constant BOB = address(0xB);
    address public constant CAROL = address(0xC);

    // Token interfaces
    IERC20 public constant DAI = IERC20(DAI_A);
    IERC20 public constant WETH = IERC20(WETH_A);
    IERC20 public constant USDC = IERC20(USDC_A);

    // Test option
    uint256 private testOptionId;
    address private testUnderlyingAsset = WETH_A;
    uint40 private testExerciseTimestamp;
    uint40 private testExpiryTimestamp;
    address private testExerciseAsset = DAI_A;
    uint96 private testUnderlyingAmount = 7 ether; // NOTE: uneven number to test for division rounding
    uint96 private testExerciseAmount = 3000 ether;
    uint256 private testDuration = 1 days;

    IOptionSettlementEngine.Option private testOption;

    OptionSettlementEngine public engine;
    IValoremERC20Factory public factory;

    function setUp() public {
        vm.createSelectFork(vm.envString("RPC_URL"), 15_000_000); // specify block number to cache for future test runs
        engine = new OptionSettlementEngine(address(42), address(69));
        factory = new ValoremERC20Factory(address(engine));

        // Setup test option contract
        testExerciseTimestamp = uint40(block.timestamp);
        testExpiryTimestamp = uint40(block.timestamp + testDuration);
        (testOptionId, testOption) = _createNewOptionType({
            underlyingAsset: testUnderlyingAsset,
            underlyingAmount: testUnderlyingAmount,
            exerciseAsset: testExerciseAsset,
            exerciseAmount: testExerciseAmount,
            exerciseTimestamp: testExerciseTimestamp,
            expiryTimestamp: testExpiryTimestamp
        });

        // Pre-load balances and approvals
        address[3] memory recipients = [ALICE, BOB, CAROL];
        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];

            // Now we have 1B in stables and 10M WETH
            _writeTokenBalance(recipient, DAI_A, 1000000000 * 1e18);
            _writeTokenBalance(recipient, USDC_A, 1000000000 * 1e6);
            _writeTokenBalance(recipient, WETH_A, 10000000 * 1e18);

            // Approve settlement engine to spend ERC20 token balances
            vm.startPrank(recipient);
            WETH.approve(address(engine), type(uint256).max);
            DAI.approve(address(engine), type(uint256).max);
            USDC.approve(address(engine), type(uint256).max);
            vm.stopPrank();
        }

        // Approve test contract approval for all on settlement engine ERC1155 token balances
        engine.setApprovalForAll(address(this), true);
    }

    function testRevertWhenInvalidAddress() public {
        address invalidAddress = address(0x0);
        vm.expectRevert(abi.encodeWithSelector(IValoremERC20Factory.InvalidEngineAddress.selector, invalidAddress));
        factory = new ValoremERC20Factory(invalidAddress);
    }

    function testRevertWhenOptionTypeNotInitialized() public {
        uint160 uninitializedOptionId = 0x42;
        vm.expectRevert(
            abi.encodeWithSelector(IValoremERC20Factory.OptionTypeNotInitialized.selector, uninitializedOptionId)
        );
        factory.newWrapperToken(uninitializedOptionId, true);

        vm.expectRevert(
            abi.encodeWithSelector(IValoremERC20Factory.OptionTypeNotInitialized.selector, uninitializedOptionId)
        );
        factory.newWrapperToken(uninitializedOptionId, false);
    }

    function testRevertWhenInvalidOptionToWrap() public {
        uint160 optionId = uint160(testOptionId >> 96);
        // warp to past expiry
        vm.warp(testOption.expiryTimestamp + 1);

        vm.expectRevert(
            abi.encodeWithSelector(
                IValoremERC20Factory.InvalidOptionToWrap.selector, optionId, testOption.exerciseTimestamp
            )
        );
        factory.newWrapperToken(optionId, true);

        vm.expectRevert(
            abi.encodeWithSelector(
                IValoremERC20Factory.InvalidOptionToWrap.selector, optionId, testOption.exerciseTimestamp
            )
        );
        factory.newWrapperToken(optionId, false);
    }

    function testRevertWhenWrapperAlreadyExists() public {
        uint160 optionId = uint160(testOptionId >> 96);
        vm.warp(testOption.exerciseTimestamp - 1);
        address optionWrapper = factory.newWrapperToken(optionId, true);
        address claimWrapper = factory.newWrapperToken(optionId, false);

        vm.expectRevert(
            abi.encodeWithSelector(IValoremERC20Factory.WrapperAlreadyExists.selector, optionId, optionWrapper)
        );
        factory.newWrapperToken(optionId, true);

        vm.expectRevert(
            abi.encodeWithSelector(IValoremERC20Factory.WrapperAlreadyExists.selector, optionId, claimWrapper)
        );
        factory.newWrapperToken(optionId, false);
    }

    function testNewWrapperTokenBasic() public {
        uint160 optionId = uint160(testOptionId >> 96);
        vm.warp(testOption.exerciseTimestamp - 1);

        address optionWrapper = factory.newWrapperToken(optionId, true);
        address optionWrapper2 = factory.wrapper(testOptionId);
        assertEq(optionWrapper, optionWrapper2);

        address claimWrapper = factory.newWrapperToken(optionId, false);
        address claimWrapper2 = factory.wrapper(testOptionId + 1);
        assertEq(claimWrapper, claimWrapper2);

        claimWrapper2 = factory.wrapper(testOptionId + 2);
        assertEq(claimWrapper, claimWrapper2);

        assertFalse(optionWrapper == claimWrapper);
    }

    // copied from OptionSettlementEngine.t.sol
    function _createNewOptionType(
        address underlyingAsset,
        uint96 underlyingAmount,
        address exerciseAsset,
        uint96 exerciseAmount,
        uint40 exerciseTimestamp,
        uint40 expiryTimestamp
    ) internal returns (uint256 optionId, IOptionSettlementEngine.Option memory option) {
        (, option) = _getNewOptionType({
            underlyingAsset: underlyingAsset,
            underlyingAmount: underlyingAmount,
            exerciseAsset: exerciseAsset,
            exerciseAmount: exerciseAmount,
            exerciseTimestamp: exerciseTimestamp,
            expiryTimestamp: expiryTimestamp
        });
        optionId = engine.newOptionType({
            underlyingAsset: underlyingAsset,
            underlyingAmount: underlyingAmount,
            exerciseAsset: exerciseAsset,
            exerciseAmount: exerciseAmount,
            exerciseTimestamp: exerciseTimestamp,
            expiryTimestamp: expiryTimestamp
        });
    }

    function _getNewOptionType(
        address underlyingAsset,
        uint96 underlyingAmount,
        address exerciseAsset,
        uint96 exerciseAmount,
        uint40 exerciseTimestamp,
        uint40 expiryTimestamp
    ) internal pure returns (uint256 optionId, IOptionSettlementEngine.Option memory option) {
        option = IOptionSettlementEngine.Option({
            underlyingAsset: underlyingAsset,
            underlyingAmount: underlyingAmount,
            exerciseAsset: exerciseAsset,
            exerciseAmount: exerciseAmount,
            exerciseTimestamp: exerciseTimestamp,
            expiryTimestamp: expiryTimestamp,
            settlementSeed: 0, // default zero for settlement seed
            nextClaimNum: 0 // default zero for next claim id
        });
        optionId = _createOptionIdFromStruct(option);
    }

    function _createOptionIdFromStruct(IOptionSettlementEngine.Option memory optionInfo)
        internal
        pure
        returns (uint256)
    {
        uint160 optionKey = uint160(bytes20(keccak256(abi.encode(optionInfo))));

        return uint256(optionKey) << 96;
    }

    function _writeTokenBalance(address who, address token, uint256 amt) internal {
        stdstore.target(token).sig(IERC20(token).balanceOf.selector).with_key(who).checked_write(amt);
    }
}
