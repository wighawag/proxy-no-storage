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
        
        // address implementationAddress
        // if (isContract(address(_implementationConfiguration))) {
        //     implementationAddress = _implementationConfiguration.implementation();
        //     console.log("use implementation from bytecode: %s", implementationAddress);
        // } else {
        //     implementationAddress = _implementationConfigurationRegistry.lastImplementation();
        //     console.log("use implementation from storage: %s", implementationAddress);
        // }

        // The following fails because even with low level call solidity check if there is code
        // address implementationAddress
        // bytes memory returnData;
        // bool s;
        // (s, returnData) = address(_implementationConfiguration).call(abi.encodeWithSelector(_implementationConfiguration.implementation.selector));
        // if (!s) {
        //     console.log("impl: '%s'", string(returnData));
        //     (s, returnData) = address(_implementationConfigurationRegistry).call(abi.encodeWithSelector(_implementationConfigurationRegistry.lastImplementation.selector));
        //     require(s, string(returnData)); // TODO raw returnData   
        // }
        // implementationAddress = abi.decode(returnData, (address));

        // same here:
        // address implementationAddress
        // try _implementationConfiguration.implementation() returns(address implementation) {
        //     console.log("impl: '%s'", implementation);
        //     implementationAddress = implementation;
        // } catch{
        //     // SO that it still work between the selfDestruct and upgrade
        //     implementationAddress = _implementationConfigurationRegistry.lastImplementation();
        //     console.log("noimpl: '%s'", implementationAddress);
        // }

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
        assembly {
            let ptr := mload(0x40)
            mstore(ptr,input)
            success := staticcall(3000, implementationConfigurationAddress, ptr, 0x04, ptr, 0x20)
            implementation := mload(ptr)
            mstore(0x40,add(ptr,0x04))
        }
        success = success && implementation != address(0);
    }

    // function isContract(address addr) internal view returns (bool) {
    //     // for accounts without code, i.e. `keccak256('')`:
    //     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

    //     bytes32 codehash;
    //     // solium-disable-next-line security/no-inline-assembly
    //     assembly {
    //         codehash := extcodehash(addr)
    //     }
    //     return (codehash != 0x0 && codehash != accountHash);
    // }
}
