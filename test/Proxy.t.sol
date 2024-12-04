// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Proxy} from "../src/Proxy.sol";

// Mock implementation contract for testing
contract MockImplementation {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }
}

contract ProxyTest is Test {
    Proxy public proxy;
    MockImplementation public implementation;
    address public implementation2;
    address public admin;
    address public newAdmin;
    address public randomUser;

    function setUp() public {
        // Set up test addresses
        admin = makeAddr("admin");
        newAdmin = makeAddr("newAdmin");
        randomUser = makeAddr("randomUser");
        implementation = new MockImplementation();
        implementation2 = makeAddr("implementation2");

        // Deploy proxy as admin
        vm.prank(admin);
        proxy = new Proxy(address(implementation));
    }

    // Test constructor and initial state
    function testInitialState() public {
        assertEq(proxy.getAdmin397fa(), admin, "Admin should be set to deployer");
        assertEq(proxy.getImplementation1599d(), address(implementation), "Implementation should be set correctly");
    }

    // Test admin change functionality
    function testsetAdmin17e0ByAdmin() public {
        vm.prank(admin);
        proxy.setAdmin17e0(newAdmin);
        assertEq(proxy.getAdmin397fa(), newAdmin, "Admin should be updated");
    }

    // Test preventing non-admin from changing admin
    function testCannotsetAdmin17e0ByNonAdmin() public {
        vm.prank(randomUser);
        vm.expectRevert(bytes("nope"));
        proxy.setAdmin17e0(randomUser);
    }

    // Test implementation change functionality
    function testsetImplementation743aByAdmin() public {
        vm.prank(admin);
        proxy.setImplementation743a(implementation2);
        assertEq(proxy.getImplementation1599d(), implementation2, "Implementation should be updated");
    }

    // Test preventing non-admin from changing implementation
    function testCannotsetImplementation743aByNonAdmin() public {
        vm.prank(randomUser);
        vm.expectRevert(bytes("nope"));
        proxy.setImplementation743a(implementation2);
    }

    // Test delegate call functionality
    function testDelegateCall() public {
        // Create a proxy instance that can be cast to the mock implementation
        MockImplementation proxiedImplementation = MockImplementation(address(proxy));

        // Set value through proxy (which uses delegatecall)
        proxiedImplementation.setValue(42);

        // Check that the value is stored in the proxy's storage, not the implementation
        assertEq(proxiedImplementation.getValue(), 42, "Value should be set via delegatecall");
    }
    // Fuzz test for admin change

    function testFuzzsetAdmin17e0(address fuzzyNewAdmin) public {
        vm.prank(admin);
        proxy.setAdmin17e0(fuzzyNewAdmin);
        assertEq(proxy.getAdmin397fa(), fuzzyNewAdmin, "Admin should be set to fuzzy address");
    }
}
