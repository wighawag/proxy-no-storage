// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "@nomiclabs/buidler/console.sol";

contract NewImplementation {
    function sayHello() external pure returns (string memory) {
        return "Hello New World";
    }
}
