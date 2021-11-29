// SPDX-License-Identifier: UNLICENSED
//Contract Address : 0xF2c323c6D66f87cbE8E49c47B65AbDd8B17245cc
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract GreetingsPortal {

    uint256 greetingCount;
    mapping(address => uint) public greetingList;

    uint256 private seed;

    event NewGreet(address indexed from, uint256 timestamp, string message);

    struct Greeting{
        address greeter;
        string message;
        uint256 timestamp;
    }

    Greeting[] greets;

    mapping(address => uint256) public lastGreetedAt;

    constructor() payable{
        console.log("GM, I AM A SMART CONTRACT, READY TO SERVE YOU.");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function greet(string memory _message) public{

        require( 
            lastGreetedAt[msg.sender] + 5 minutes < block.timestamp,
            "Wait 5 Minutes before sending another Greeting!"
        );

        lastGreetedAt[msg.sender] = block.timestamp;

        greetingCount += 1;
        greetingList[msg.sender] += 1;
        console.log("%s has sent their Greetings! (%s)", msg.sender, _message);

        greets.push(Greeting(msg.sender, _message, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;

        if(seed <= 30){
            console.log("%s won", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
            
        }

        emit NewGreet(msg.sender, block.timestamp, _message);

    }

    function getAllGreets() public view returns(Greeting[] memory){
        return greets;
    }

    function getGreetingCount() public view returns(uint256, uint256){
        console.log("We have %d Greetings!", greetingCount);
        console.log("%s has sent %d Greetings!", msg.sender, greetingList[msg.sender]);
        return (greetingCount, greetingList[msg.sender]);

    }
}