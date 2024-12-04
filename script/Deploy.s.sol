// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Wallet1} from "../src/Wallet1.sol";
import {Wallet2} from "../src/Wallet2.sol";
import {Wallet3} from "../src/Wallet3.sol";
import {Proxy} from "../src/Proxy.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.createWallet(deployerPrivateKey).addr;
        vm.startBroadcast(deployerPrivateKey);

        Wallet1 wallet1 = new Wallet1();
        Wallet2 wallet2 = new Wallet2();
        Wallet3 wallet3 = new Wallet3();
        Proxy proxy = new Proxy(address(wallet1));
        Wallet1 proxyWallet = Wallet1(payable(address(proxy)));
        proxyWallet.initialize59ad(deployer);
        payable(address(proxy)).call{value: 50 ether}("");

        vm.stopBroadcast();

        console.log("Wallet1", address(wallet1));
        console.log("Wallet2", address(wallet2));
        console.log("Wallet3", address(wallet3));
        console.log("Proxy", address(proxy));
        console.log("Deployer", deployer);
    }
}
