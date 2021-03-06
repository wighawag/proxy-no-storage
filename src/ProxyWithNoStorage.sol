// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "./ImplementationConfiguration.sol";
import "./ImplementationConfigurationRegistry.sol";
import "@nomiclabs/buidler/console.sol";


contract ProxyWithNoStorage {

    ImplementationConfiguration internal immutable _implementationConfiguration;
    ImplementationConfigurationRegistry internal immutable _implementationConfigurationRegistry;
    constructor(ImplementationConfiguration implementationConfiguration, ImplementationConfigurationRegistry implementationConfigurationRegistry) {
        _implementationConfiguration = implementationConfiguration;
        _implementationConfigurationRegistry = implementationConfigurationRegistry;
    }
    
    // ///////////////////// EXTERNAL ///////////////////////////////////////////////////////////////////////////

    receive() external payable {
        _fallback();
    }

    fallback() external payable {
        _fallback();
    }

    // ///////////////////////// INTERNAL //////////////////////////////////////////////////////////////////////

    function _fallback() internal {
        (bool readingSuccess, address implementationAddress) = readImplementation();
        if (!readingSuccess) {
            implementationAddress = _implementationConfigurationRegistry.lastImplementation();
            console.log("use implementation from storage: %s", implementationAddress);
        }
        
        // solhint-disable-next-line security/no-inline-assembly
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            let success := delegatecall(gas(), implementationAddress, 0x0, calldatasize(), 0, 0)
            let retSz := returndatasize()
            returndatacopy(0, 0, retSz)
            switch success
                case 0 {
                    revert(0, retSz)
                }
                default {
                    return(0, retSz)
                }
        }
    }

    function readImplementation() internal view returns(bool success, address implementation) {
        bytes4 input = _implementationConfiguration.implementation.selector;
        address implementationConfigurationAddress = address(_implementationConfiguration);
        // solhint-disable-next-line security/no-inline-assembly
        assembly {
            let ptr := mload(0x40)
            mstore(ptr,input)
            success := staticcall(3000, implementationConfigurationAddress, ptr, 0x04, ptr, 0x20)
            implementation := mload(ptr)
            mstore(0x40,add(ptr,0x04))
        }
        success = success && implementation != address(0);
    }
}
