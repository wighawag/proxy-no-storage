// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "./ImplementationConfiguration.sol";

contract ProxyWithNoStorage {

    ImplementationConfiguration internal immutable _implementationConfiguration;
    constructor(ImplementationConfiguration implementationConfiguration) {
        _implementationConfiguration = implementationConfiguration;
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
        address implementationAddress = _implementationConfiguration.implementation();
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
}
