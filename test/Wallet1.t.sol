// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Wallet1} from "../src/Wallet1.sol";

contract Wallet1Test is Test {
    Wallet1 public wallet;
    address public owner;
    address public recipient;
    address public newOwner;
    address public randomUser;

    function setUp() public {
        owner = makeAddr("owner");
        recipient = makeAddr("recipient");
        newOwner = makeAddr("newOwner");
        randomUser = makeAddr("randomUser");

        wallet = new Wallet1();
        wallet.initialize59ad(owner);

        // Fund wallet with 10 ether for distribution tests
        vm.deal(address(wallet), 10 ether);
    }

    function testInitialState() public {
        assertEq(wallet.getOwner15569(), owner, "Owner should be contract deployer");
    }

    function testReinitialize() public {
        vm.expectRevert(bytes("nope"));
        wallet.initialize59ad(owner);
    }

    function testDistributeByOwner() public {
        uint256 recipientBalanceBefore = recipient.balance;
        
        vm.broadcast(owner);
        wallet.distribute38c1b(recipient);

        assertEq(
            recipient.balance, 
            recipientBalanceBefore + 0.5 ether, 
            "Recipient should receive 0.5 ether"
        );
    }

    function testCannotDistributeByNonOwner() public {
        vm.broadcast(randomUser);
        vm.expectRevert(bytes("nope"));
        wallet.distribute38c1b(recipient);
    }

    function testchangeOwner1da7bByOwner() public {
        vm.broadcast(owner);
        wallet.changeOwner1da7b(newOwner);

        assertEq(wallet.getOwner15569(), newOwner, "Owner should be changed");
    }

    function testCannotchangeOwner1da7bByNonOwner() public {
        vm.broadcast(randomUser);
        vm.expectRevert(bytes("nope"));
        wallet.changeOwner1da7b(newOwner);
    }

    // Fuzz tests for owner change and distribution
    function testFuzzchangeOwner1da7b(address fuzzyNewOwner) public {
        vm.broadcast(owner);
        wallet.changeOwner1da7b(fuzzyNewOwner);
        assertEq(wallet.getOwner15569(), fuzzyNewOwner, "Owner should be changed to fuzzy address");
    }

    // Specific test for tx.origin check
    function testTxOriginCheck() public {
        vm.startPrank(randomUser, owner);
        wallet.distribute38c1b(recipient);
        vm.stopPrank();
    }

    // Receive function test
    function testReceive() public {
        uint256 walletBalanceBefore = address(wallet).balance;
        
        vm.deal(randomUser, 1 ether);
        vm.prank(randomUser);
        (bool success, ) = address(wallet).call{value: 0.5 ether}("");
        
        assertTrue(success, "Recipient should accept ether");
        assertEq(
            address(wallet).balance, 
            walletBalanceBefore + 0.5 ether, 
            "Wallet balance should increase"
        );
    }
}