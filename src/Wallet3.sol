// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Wallet3 {
    address private owner;
    bytes32[] private notes;

    event NoteAdded(bytes32 note, uint256 index);
    event Sent(address recipient);

    modifier onlyOwner() {
        require(tx.origin == owner, "nope");
        _;
    }

    function initialize59ad(address _owner) public {
        require(owner == address(0), "nope");
        owner = _owner;
    }

    function send47de(address recipient) public onlyOwner {
        (bool success,) = payable(recipient).call{value: 0.5 ether}("");
        require(success, "Recipient should accept ether");
        emit Sent(recipient);
    }

    function addNote3dee(bytes32 note) public onlyOwner {
        notes.push(note);
        emit NoteAdded(note, notes.length - 1);
    }

    function getOwner15569() public view returns (address) {
        return owner;
    }

    function getNote179e(uint256 index) public view returns (bytes32) {
        return notes[index];
    }

    receive() external payable {}
}
