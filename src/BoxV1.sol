// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal value;

    constructor() {
        _disableInitializers();
    }

    // Replaces the constructor(being called immediately when the proxy contract is deployed)
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        // Does nothing (but it's best practice so we can see it's an upgradable contract)
        __UUPSUpgradeable_init();
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    // We need to implement this function from UUPSUpgradeable which decides who is able to updade the contract(in our case everyone is able to do it, that's why it's blank)
    function _authorizeUpgrade(address newImplementation) internal override {}
}
