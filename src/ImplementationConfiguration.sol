// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "@nomiclabs/buidler/console.sol";
import "./ImplementationConfigurationRegistry.sol";

contract ImplementationConfiguration {

    address public immutable implementation;
    constructor(ImplementationConfigurationRegistry registry) {
        implementation = registry.implementation();
    }

    // TODO NOT_AUTHORIZED
    function destroy(address payable recipient) external {
        selfdestruct(recipient);
    }
}
