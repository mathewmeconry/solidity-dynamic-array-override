// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Wallet2} from "../src/Wallet2.sol";

contract Wallet2Test is Test {
    Wallet2 public wallet;
    address public owner;
    address public recipient;
    address public newOwner;
    address public randomUser;

    function setUp() public {
        owner = makeAddr("owner");
        recipient = makeAddr("recipient");
        newOwner = makeAddr("newOwner");
        randomUser = makeAddr("randomUser");

        wallet = new Wallet2();
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
        
        vm.prank(owner);
        wallet.gift1a6e9(recipient);

        assertEq(
            recipient.balance, 
            recipientBalanceBefore + 0.5 ether, 
            "Recipient should receive 0.5 ether"
        );
    }

    function testCannotDistributeByNonOwner() public {
        vm.broadcast(randomUser);
        vm.expectRevert(bytes("nope"));
        wallet.gift1a6e9(recipient);
    }

    function testchangeOwner1c104ByOwner() public {
        vm.prank(owner);
        wallet.changeOwner1c104(newOwner);

        assertEq(wallet.getOwner15569(), newOwner, "Owner should be changed");
    }

    function testCannotchangeOwner1c104ByNonOwner() public {
        vm.broadcast(randomUser);
        vm.expectRevert(bytes("nope"));
        wallet.changeOwner1c104(newOwner);
    }

    // Fuzz tests for owner change and distribution
    function testFuzzchangeOwner1c104(address fuzzyNewOwner) public {
        vm.prank(owner);
        wallet.changeOwner1c104(fuzzyNewOwner);
        assertEq(wallet.getOwner15569(), fuzzyNewOwner, "Owner should be changed to fuzzy address");
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