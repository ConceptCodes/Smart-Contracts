// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";

/// @title HQ trivia game
/// @author concept
/// @notice allows you to answer questions to win money
contract HQ is Ownable {
    mapping(string => Question) questions;
    
    struct Question {
        string prompt;
        string answer;
        bool correct;
    }

    constructor() Ownable() { 
        // load in the questions and hash the answers
    }
    
    /// @notice fund the contract with ether
    /// @dev only the owner can send ether to the contract
    receive() external payable  onlyOwner {
        
    }

    /// @notice how you answer the quesstion
    /// @dev checks if your guess properly matches the question's answer
    /// @param _answer your answer to the question
    /// @param _question the question your curretly ansewring
    /// @return true if answer is correct
    function guess(string memory _question, string memory _answer) public view returns (bool) {
        if(keccak256(abi.encodePacked(questions[_question].answer)) == _answer){
            questions[_question].correct = true;
        } else{
            
        }
    }



    /// @notice gives you the prize money
    /// @return the current contract balance
    function getBalance() external returns(uint256) {
        return address(this).balance;
    }
}