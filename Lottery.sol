// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/// @title HQ trivia game
/// @author concept
/// @notice allows you to answer questions to win money
contract HQ is Ownable {
    mapping(string => Question) public _quiz;
    string[] public questions;
    uint256 public _count = 0;
    
    struct Question {
        string prompt;
        bytes32 answer;
    }

    /// @notice a new question has been added
    /// @param _question the question that was given
    /// @param _answer the answer that question
    event QuestionAdded(string _question, string _answer);

    /// @notice alert that player has answered correctly
    /// @param _question the question that was answered
    /// @param _answer the answer that was given
    event CorrectAnswer(string _question, string _answer);

    event WinnerChosen(address _winner);

    modifier notOnwer {
        require(msg.sender != owner(), "Owner cannot participate");
        _;
    }

    constructor() Ownable() {  }

    /// @notice add a new question
    /// @dev make sure the question length is 
    function addQuestion(string memory _question, string memory _answer) external onlyOwner {
        _quiz[_question] = Question({
            prompt: _question,
            answer: keccak256(abi.encodePacked(_answer))
        });
        questions.push(_question);
        emit QuestionAdded(_question, _answer);
    }

    /// @notice the questions for this quiz
    /// @return the questions array
    function getQuestions() public view returns(string[] memory) {
        return questions;
    }
    
    /// @notice fund the contract with ether
    /// @dev only the owner can send ether to the contract
    receive() external payable onlyOwner {
        require(getBalance() == 0, "Prize money has already been set");
        require(msg.value >= 1 ether, "Minimum amount is 1 ether");
    }

    /// @notice how you answer the question
    /// @dev checks if your guess properly matches the question's answer
    /// @param _answer your answer to the question
    /// @param _question the question your curretly ansewring
    function guess(string memory _question, string memory _answer) public notOnwer {
        require(keccak256(abi.encodePacked(_quiz[_question].answer)) == keccak256(abi.encodePacked(_answer)), "Sorry your answer was incorrect");
        emit CorrectAnswer(_question, _answer);
        _count++;
    }

    /// @notice collect your prize money
    /// @dev if you have answered all the questions correctly you can withdraw the contract balance
    function withdraw() external notOnwer {
        require(_count == questions.length, "Sorry you need to answer all the questions correctly");
        for(uint i = 0; i <= questions.length; i++) {
           delete _quiz[questions[i]]; 
        }
        delete questions;
        (bool success, ) = payable(msg.sender).call{value: getBalance()}("");
        require(success, "refund was unsuccessful");
        assert(getBalance() == 0);
        emit WinnerChosen(msg.sender);
    }

    /// @notice the prize money
    /// @return the current contract balance
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}
