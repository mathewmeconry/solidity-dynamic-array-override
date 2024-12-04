// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Proxy} from "../src/Proxy.sol";
import {Wallet3} from "../src/Wallet3.sol";

contract TestSetupWallet3 is Test {
    address owner;
    Proxy proxy;
    Wallet3 wallet3;
    Wallet3 proxyWallet;

    function setUp() public {
        owner = makeAddr("owner");
        wallet3 = new Wallet3();
        proxy = new Proxy(address(wallet3));
        proxyWallet = Wallet3(payable(address(proxy)));
        proxyWallet.initialize59ad(owner);
        vm.deal(address(proxy), 10 ether);
    }

    function testInitialState() public {
        assertEq(proxyWallet.getOwner15569(), address(owner), "Owner should be contract deployer");
        assertEq(proxy.getImplementation1599d(), address(wallet3), "Implementation should be set correctly");
    }

    function testReinitialize() public {
        vm.expectRevert(bytes("nope"));
        proxyWallet.initialize59ad(owner);
    }

    function testShouldSend(address fuzzyRecipient) public {
        vm.assume(fuzzyRecipient.code.length == 0);
        vm.assume(fuzzyRecipient > address(20));

        uint256 balanceBefore = fuzzyRecipient.balance;
        vm.broadcast(owner);
        proxyWallet.send47de(fuzzyRecipient);
        assertEq(fuzzyRecipient.balance, balanceBefore + 0.5 ether, "Recipient should receive 0.5 ether");
    }

    function testShouldSendFail(address fuzzyRecipient) public {
        vm.broadcast(makeAddr("randomUser"));
        vm.expectRevert(bytes("nope"));
        proxyWallet.send47de(fuzzyRecipient);
    }

    function testShouldAddNote(bytes32 fuzzyNote) public {
        vm.broadcast(owner);
        proxyWallet.addNote3dee(fuzzyNote);
    }

    function testShouldAddNoteFail(bytes32 fuzzyNote) public {
        vm.broadcast(makeAddr("randomUser"));
        vm.expectRevert(bytes("nope"));
        proxyWallet.addNote3dee(fuzzyNote);
    }
}
