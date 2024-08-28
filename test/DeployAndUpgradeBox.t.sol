// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeBox is Test {
    DeployBox deployer;
    UpgradeBox upgrader;

    address public proxy;

    function setUp() external {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run(); // points to proxy of boxV1
    }
    
    function testRevertsSetValueBeforeUpgrade() public {
        vm.expectRevert();
        BoxV2(proxy).setValue(777);
    }

    function testUpgrade() public {
        BoxV2 boxV2Proxy = new BoxV2();
        // upgrading proxy to point to implementation of boxV2
        upgrader.upgradeBox(proxy, address(boxV2Proxy));

        // so now calling version function on boxV1 it should use the implementation of boxV1
        uint256 version = BoxV1(proxy).version();
        uint256 setValue = 777;

        // calling proxy address now points to the implementation of boxV2 so it has the setValue function on it
        BoxV2(proxy).setValue(setValue);    
        assert(version == 2);
        assert(BoxV2(proxy).getValue() == setValue);
    }
}