// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Wallet2 {
    address private owner;

    event Gifted(address recipient);
    event OwnerChanged(address newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "nope");
        _;
    }

    function initialize59ad(address _owner) public {
        require(owner == address(0), "nope");
        owner = _owner;
    }

    function gift1a6e9(address recipient) public onlyOwner {
        (bool success, ) = payable(recipient).call{value: 0.5 ether}("");
        require(success, "Recipient should accept ether");
        emit Gifted(recipient);
    }

    function changeOwner1c104(address newOwner) public onlyOwner {
        owner = newOwner;
        emit OwnerChanged(newOwner);
    }

    function getOwner15569() public view returns (address) {
        return owner;
    }

    receive() external payable {}
}
