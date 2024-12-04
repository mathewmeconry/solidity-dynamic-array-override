// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Proxy} from "../src/Proxy.sol";
import {Wallet2} from "../src/Wallet2.sol";

contract ReentrancyTest {
    function reenter() internal {
        (bool success, ) = msg.sender.call(abi.encodeWithSelector(Wallet2.changeOwner1c104.selector, address(this)));
        require(success);
    }

    receive() external payable {
        reenter();
    }
}

contract TestSetupWallet2 is Test {
    address owner;
    Proxy proxy;
    Wallet2 wallet2;
    Wallet2 proxyWallet;

    function setUp() public {
        owner = makeAddr("owner");
        wallet2 = new Wallet2();
        proxy = new Proxy(address(wallet2));
        proxyWallet = Wallet2(payable(address(proxy)));
        proxyWallet.initialize59ad(owner);
        vm.deal(address(proxy), 10 ether);
    }

    function testInitialState() public {
        assertEq(proxyWallet.getOwner15569(), owner, "Owner should be contract deployer");
        assertEq(proxy.getImplementation1599d(), address(wallet2), "Implementation should be set correctly");
    }

    function testReinitialize() public {
        vm.expectRevert(bytes("nope"));
        proxyWallet.initialize59ad(owner);
    }

    function testShouldGift(address fuzzyRecipient) public {
        vm.assume(fuzzyRecipient.code.length == 0);
        vm.assume(fuzzyRecipient > address(20));

        uint256 balanceBefore = fuzzyRecipient.balance;
        vm.prank(owner);
        proxyWallet.gift1a6e9(fuzzyRecipient);
        assertEq(fuzzyRecipient.balance, balanceBefore + 0.5 ether, "Recipient should receive 0.5 ether");
    }

    function testShouldGiftFail(address fuzzyRecipient) public {
        vm.prank(makeAddr("randomUser"));
        vm.expectRevert(bytes("nope"));
        proxyWallet.gift1a6e9(fuzzyRecipient);
    }

    function testShouldChangeOwner(address fuzzyNewOwner) public {
        vm.prank(owner);
        proxyWallet.changeOwner1c104(fuzzyNewOwner);
        assertEq(proxyWallet.getOwner15569(), fuzzyNewOwner, "Owner should be changed to fuzzy address");
    }

    function testShouldChangeOwnerFail(address fuzzyNewOwner) public {
        vm.prank(makeAddr("randomUser"));
        vm.expectRevert(bytes("nope"));
        proxyWallet.changeOwner1c104(fuzzyNewOwner);
    }

    function testShouldFailToReenter() public {
        ReentrancyTest attacker = new ReentrancyTest();
        vm.expectRevert(bytes("Recipient should accept ether"));
        vm.prank(owner);
        proxyWallet.gift1a6e9(payable(address(attacker)));
        assertEq(proxyWallet.getOwner15569(), owner, "Owner should be contract deployer");
    }
}
