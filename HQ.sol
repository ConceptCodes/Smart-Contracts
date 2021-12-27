// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";

/// @title HQ trivia game
/// @author concept
/// @notice allows you to answer questions to win money
contract HQ is Ownable {
    mapping(string => Question) quiz;
    
    struct Question {
        string prompt;
        string answer;
        bool correct;
    }

    event questionAnswered(bool guess);

    constructor() Ownable() { 
        quiz["Q1"] = Question({
            prompt: "Q1",
            answer: keccak256(abi.encodePacked("A1")),
            correct: false
        });
        quiz["Q2"] = Question({
            prompt: "Q2",
            answer: keccak256(abi.encodePacked("A2")),
            correct: false
        });
        quiz["Q3"] = Question({
            prompt: "Q3",
            answer: keccak256(abi.encodePacked("A3")),
            correct: false
        });
    }
    
    /// @notice fund the contract with ether
    /// @dev only the owner can send ether to the contract
    receive() external payable onlyOwner {
        require(msg.value >= 1 ether, "Minimum amount is 1 ether");
    }

    /// @notice how you answer the question
    /// @dev checks if your guess properly matches the question's answer
    /// @param _answer your answer to the question
    /// @param _question the question your curretly ansewring
    function guess(string memory _question, string memory _answer) external view  {
        if(keccak256(abi.encodePacked(quiz[_question].answer)) == _answer){
            quiz[_question].correct = true;
            emit questionAnswered(true);
        } else{
            emit questionAnswered(false);
            revert("Sorry your answer was incorrect")
        }
    }

    /// @notice gives you the prize money
    /// @return the current contract balance
    function getBalance() external returns(uint256) {
        return address(this).balance;
    }
}