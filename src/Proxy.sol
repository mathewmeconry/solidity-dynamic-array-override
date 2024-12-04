// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Proxy {
    bytes32 internal constant ADMIN_SLOT =
        0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0d00;
    bytes32 internal constant IMPLEMENTATION =
        0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cfb;

    constructor(address _implementation) {
        address admin = msg.sender;

        assembly {
            sstore(ADMIN_SLOT, admin)
            sstore(IMPLEMENTATION, _implementation)
        }
    }

    function getAdmin397fa() public view returns (address) {
        bytes32 slot = ADMIN_SLOT;
        bytes32 admin;
        assembly {
            admin := sload(slot)
        }
        return address(uint160(uint256(admin)));
    }

    function setAdmin17e0(address newAdmin) public {
        require(msg.sender == getAdmin397fa(), "nope");
        bytes32 slot = ADMIN_SLOT;
        assembly {
            sstore(slot, newAdmin)
        }
    }

    function getImplementation1599d() public view returns (address) {
        bytes32 slot = IMPLEMENTATION;
        bytes32 implementation;
        assembly {
            implementation := sload(slot)
        }
        return address(uint160(uint256(implementation)));
    }

    function setImplementation743a(address newImplementation) public {
        require(msg.sender == getAdmin397fa(), "nope");
        bytes32 slot = IMPLEMENTATION;
        assembly {
            sstore(slot, newImplementation)
        }
    }

    function _delegate() private {
        address implementation = getImplementation1599d();
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    fallback() external {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }
}
