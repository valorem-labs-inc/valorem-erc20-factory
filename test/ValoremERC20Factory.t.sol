// SPDX-License-Identifier: BUSL 1.1
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import "valorem-core/OptionSettlementEngine.sol";

import "../src/ValoremERC20Factory.sol";

contract ValoremERC20FactoryTest is Test {
    using stdStorage for StdStorage;

    IOptionSettlementEngine private engine;
    IValoremERC20Factory private factory;

    function setUp() public {
        engine = new OptionSettlementEngine(address(0xdadcafe), address(0xbeefbeef));
        factory = new ValoremERC20Factory(address(engine));
    }

    function testRevertWhenInvalidAddress() public {
        address invalidAddress = address(0x0);
        vm.expectRevert(abi.encodeWithSelector(IValoremERC20Factory.InvalidEngineAddress.selector, invalidAddress));
        factory = new ValoremERC20Factory(invalidAddress);
    }
}
