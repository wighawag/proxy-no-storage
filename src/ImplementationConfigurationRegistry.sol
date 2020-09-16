// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "@nomiclabs/buidler/console.sol";

contract ImplementationConfigurationRegistry {
    address public lastImplementation;
    address public implementation;
    address internal _owner;

    constructor(address owner, address initialImplementation) {
        _owner = owner;
        implementation = initialImplementation;
    }

    function setImplementation(address newImplementation) external {
        require(msg.sender == _owner, "NOT_AUTHORIZED");
        lastImplementation = implementation;
        implementation = newImplementation;
    }
}
