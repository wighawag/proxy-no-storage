// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "@nomiclabs/buidler/console.sol";

contract ImplementationConfigurationRegistry {
    address public lastImplementation;
    address public implementation;
    address public owner;

    constructor(address initialOwner, address initialImplementation) {
        owner = initialOwner;
        implementation = initialImplementation;
    }

    function setImplementation(address newImplementation) external {
        require(msg.sender == owner, "NOT_AUTHORIZED");
        lastImplementation = implementation;
        implementation = newImplementation;
    }
}
