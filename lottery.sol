// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Lotery {
    address public owner;
    address payable[] public players; //can receive payement = payabale keyword
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory; 

    constructor(){
        owner = msg.sender;
        lotteryId = 1;
    }

    function enter() public payable {
        require(msg.value > .01 ether);

        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner{
        
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance); //send money to the winner

        lotteryId++;
        lotteryHistory[lotteryId] = players[index]; //keep an track of winners

        // reset the state of the contract
        players = new address payable[](0);
    }

    modifier onlyOwner()
    {
        require(msg.sender == owner, "only the master could execute this function");
        _;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

    function getPlayer() public view returns (address payable[] memory){ //memory means that it will temporary only used during this function lifecycle
        return players;
    }
}