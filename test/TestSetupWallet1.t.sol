// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Proxy} from "../src/Proxy.sol";
import {Wallet1} from "../src/Wallet1.sol";

contract ReentrancyTest {
    function reenter() public {
        (bool success,) = msg.sender.call(abi.encodeWithSelector(Wallet1.changeOwner1da7b.selector, address(this)));
        require(success);
    }

    receive() external payable {
        reenter();
    }
}

contract TestSetupWallet1 is Test {
    address owner;
    Proxy proxy;
    Wallet1 wallet1;
    Wallet1 proxyWallet;

    function setUp() public {
        owner = makeAddr("owner");
        wallet1 = new Wallet1();
        proxy = new Proxy(address(wallet1));
        proxyWallet = Wallet1(payable(address(proxy)));
        proxyWallet.initialize59ad(owner);
        vm.deal(address(proxy), 10 ether);
    }

    function testInitialState() public {
        assertEq(proxyWallet.getOwner15569(), address(owner), "Owner should be contract deployer");
        assertEq(proxy.getImplementation1599d(), address(wallet1), "Implementation should be set correctly");
    }

    function testReinitialize() public {
        vm.expectRevert(bytes("nope"));
        proxyWallet.initialize59ad(owner);
    }

    function testShouldDistribute(address fuzzyRecipient) public {
        vm.assume(fuzzyRecipient.code.length == 0);
        vm.assume(fuzzyRecipient > address(20));

        uint256 balanceBefore = fuzzyRecipient.balance;
        vm.broadcast(owner);
        proxyWallet.distribute38c1b(fuzzyRecipient);
        assertEq(fuzzyRecipient.balance, balanceBefore + 0.5 ether, "Recipient should receive 0.5 ether");
    }

    function testShouldDistributeFail(address fuzzyRecipient, address fuzzySender) public {
        vm.assume(fuzzySender != owner);
        vm.broadcast(fuzzySender);
        vm.expectRevert(bytes("nope"));
        proxyWallet.distribute38c1b(fuzzyRecipient);
    }

    function testShouldchangeOwner1da7b(address fuzzyNewOwner) public {
        vm.broadcast(owner);
        proxyWallet.changeOwner1da7b(fuzzyNewOwner);
        assertEq(proxyWallet.getOwner15569(), fuzzyNewOwner, "Owner should be changed to fuzzy address");
    }

    function testShouldchangeOwner1da7bFail(address fuzzyNewOwner, address fuzzySender) public {
        vm.assume(fuzzySender != owner);
        vm.broadcast(fuzzySender);
        vm.expectRevert(bytes("nope"));
        proxyWallet.changeOwner1da7b(fuzzyNewOwner);
    }

    function testShouldFailToReenter() public {
        ReentrancyTest attacker = new ReentrancyTest();
        vm.broadcast(owner);
        vm.expectRevert(bytes("Recipient should accept ether"));
        proxyWallet.distribute38c1b(payable(address(attacker)));
        assertEq(proxyWallet.getOwner15569(), owner, "Owner should be contract deployer");
    }
}
