// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import "valorem-core/src/OptionSettlementEngine.sol";
import "valorem-core/test/OptionSettlementEngine.t.sol";

import "../src/ValoremERC20Factory.sol";

contract ValoremERC20FactoryTest is Test {
    using stdStorage for StdStorage;

    IOptionSettlementEngine private engine;
    IValoremERC20Factory private factory;
    OptionSettlementTest private engineTest;

    function setUp() public {
        factory = new ValoremERC20Factory(address(engine));

        // test code re-use for option settlement engine
        engineTest = new OptionSettlementTest();
        engineTest.setUp();
        engine = engineTest.engine();
    }

    function testRevertWhenInvalidAddress() public {
        address invalidAddress = address(0x0);
        vm.expectRevert(abi.encodeWithSelector(IValoremERC20Factory.InvalidEngineAddress.selector, invalidAddress));
        factory = new ValoremERC20Factory(invalidAddress);
    }

    function testRevertWhenOptionTypeNotInitialized() public {
        uint160 uninitializedOptionId = 0x42;
        vm.expectRevert(abi.encodeWithSelector(IValoremERC20Factory.OptionTypeNotInitialized.selector, uninitializedOptionId));
        factory.newWrapperToken(uninitializedOptionId, true);

        vm.expectRevert(abi.encodeWithSelector(IValoremERC20Factory.OptionTypeNotInitialized.selector, uninitializedOptionId));
        factory.newWrapperToken(uninitializedOptionId, false);
    }

    function testRevertWhenInvalidOptionToWrap() public {

    }

    function testRevertWhenWrapperAlreadyExists() public {

    }

    function testNewWrapperTokenBasic() public {

    }
}
