// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value == 1 ether, "Participants must send exactly 1 ether");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function random() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager, "Only the manager can select a winner");
        require(participants.length >= 3, "At least 3 participants required");
        
        uint winnerIndex = random() % participants.length;
        address payable winner = participants[winnerIndex];
        
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}
