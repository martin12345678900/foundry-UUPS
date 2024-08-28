// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    BoxV1 boxV1;

    function run() external returns (address) {
        vm.startBroadcast();
        
        boxV1 = new BoxV1(); // Our implementation of Box contract
        ERC1967Proxy proxy = new ERC1967Proxy(address(boxV1), "");

        vm.stopBroadcast();
        return address(proxy);
    }
}
