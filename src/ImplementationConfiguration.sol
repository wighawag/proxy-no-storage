// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "@nomiclabs/buidler/console.sol";
import "./ImplementationConfigurationRegistry.sol";

contract ImplementationConfiguration {

    address public immutable implementation;
    ImplementationConfigurationRegistry public immutable registry;

    constructor(ImplementationConfigurationRegistry associatedRegistry) {
        implementation = associatedRegistry.implementation();
        registry = associatedRegistry;
    }

    function destroy(address payable recipient) external {
        require(msg.sender == registry.owner(), "NOT_AUTHORIZED");
        selfdestruct(recipient);
    }
}
