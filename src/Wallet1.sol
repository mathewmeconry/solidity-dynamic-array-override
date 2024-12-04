// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Wallet1 {
    address private owner;

    event Distributed(address recipient);
    event OwnerChanged(address newOwner);

    modifier nonreentrant {
        assembly {
            if tload(0) { revert(0, 0) }
            tstore(0, 1)
        }
        _;
        // Unlocks the guard, making the pattern composable.
        // After the function exits, it can be called again, even in the same transaction.
        assembly {
            tstore(0, 0)
        }
    }

    modifier onlyOwner() {
        require(tx.origin == owner, "nope");
        _;
    }

    function initialize59ad(address _owner) public {
        require(owner == address(0), "nope");
        owner = _owner;
    }

    function distribute38c1b(address recipient) public onlyOwner nonreentrant {
        (bool success, ) = payable(recipient).call{value: 0.5 ether}("");
        require(success, "Recipient should accept ether");
        emit Distributed(recipient);
    }

    function changeOwner1da7b(address newOwner) public onlyOwner nonreentrant {
        owner = newOwner;
        emit OwnerChanged(newOwner);
    }

    function getOwner15569() public view returns (address) {
        return owner;
    }

    receive() external payable {}
}
