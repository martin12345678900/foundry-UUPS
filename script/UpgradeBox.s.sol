// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "@devops/src/DevOpsTools.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UpgradeBox is Script {
    function run() external returns(address) {
        vm.startBroadcast();
        address latestBoxV1ProxyContract = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        BoxV2 boxV2 = new BoxV2();        
        vm.stopBroadcast();

        address proxy = upgradeBox(latestBoxV1ProxyContract, address(boxV2));
        return proxy;
    }

    function upgradeBox(address latestBoxV1ProxyContract, address newBox) public returns(address) {
        vm.startBroadcast();
        // Get deployed proxy when we deployed BoxV1
        BoxV1 oldBoxProxy = BoxV1(latestBoxV1ProxyContract);
        // Upgrade it to point to the new implementation of box (newBox)
        oldBoxProxy.upgradeToAndCall(newBox, "");
        vm.stopBroadcast();
        
        return address(oldBoxProxy);
    }
}
