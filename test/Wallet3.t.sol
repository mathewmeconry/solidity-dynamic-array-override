// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Wallet3} from "../src/Wallet3.sol";

contract Wallet3Test is Test {
    Wallet3 public wallet;
    address public owner;
    address public recipient;
    address public newOwner;
    address public randomUser;

    function setUp() public {
        owner = makeAddr("owner");
        recipient = makeAddr("recipient");
        newOwner = makeAddr("newOwner");
        randomUser = makeAddr("randomUser");

        wallet = new Wallet3();
        wallet.initialize59ad(owner);

        // Fund wallet with 10 ether for distribution tests
        vm.deal(address(wallet), 10 ether);
    }

    function testReinitialize() public {
        vm.expectRevert(bytes("nope"));
        wallet.initialize59ad(owner);
    }

    function testInitialState() public {
        assertEq(wallet.getOwner15569(), owner, "Owner should be contract deployer");
    }

    function testDistributeByOwner() public {
        uint256 recipientBalanceBefore = recipient.balance;
        
        vm.broadcast(owner);
        wallet.send47de(recipient);

        assertEq(
            recipient.balance, 
            recipientBalanceBefore + 0.5 ether, 
            "Recipient should receive 0.5 ether"
        );
    }

    function testCannotDistributeByNonOwner() public {
        vm.broadcast(randomUser);
        vm.expectRevert(bytes("nope"));
        wallet.send47de(recipient);
    }

    // Specific test for tx.origin check
    function testTxOriginCheck() public {
        vm.startPrank(randomUser, owner);
        wallet.send47de(recipient);
        vm.stopPrank();
    }

    // Receive function test
    function testReceive() public {
        uint256 walletBalanceBefore = address(wallet).balance;
        
        vm.deal(randomUser, 1 ether);
        vm.prank(randomUser);
        (bool success, ) = address(wallet).call{value: 0.5 ether}("");
        
        assertTrue(success, "Receive function should accept ether");
        assertEq(
            address(wallet).balance, 
            walletBalanceBefore + 0.5 ether, 
            "Wallet balance should increase"
        );
    }
    function testaddNote3deeByOwner() public {
        bytes32 testNote = "Test Note";

        vm.broadcast(owner);
        wallet.addNote3dee(testNote);

        assertEq(wallet.getNote179e(0), testNote, "Note should be added at specified index");
    }

    function testCannotaddNote3deeByNonOwner() public {
        vm.startPrank(randomUser);
        vm.expectRevert(bytes("nope"));
        wallet.addNote3dee("Unauthorized Note");
        vm.stopPrank();
    }

    function testFuzzaddNote3dee(bytes32 fuzzyNote) public {       
        vm.broadcast(owner);
        wallet.addNote3dee(fuzzyNote);

        assertEq(wallet.getNote179e(0), fuzzyNote, "Fuzzy note should be added");
    }
}