// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "@nomiclabs/buidler/console.sol";

contract InitialImplementation {
    function sayHello() external pure returns (string memory) {
        return "Hello World";
    }
}
