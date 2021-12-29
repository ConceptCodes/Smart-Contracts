// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "@openzeppelin/contracts/ownership/Ownable.sol";

/// @title A simple lottery in solidity
/// @author concept
/// @notice whoever wins the lottery gets the full amount of the contract balance
contract Lottery is Ownable {
    address payable[] public players;
    uint256 public minimumBet = 1 ether;
    // address payable public winner;

    constructor() Ownable() { }

    /// @notice this allows us send ether to this contract
    receive() external payable {
        require(msg.value >= minimumBet, "Minimum amount to play is 1 ether");
        require(msg.sender != owner(), "Owner cannot participate in the lottery");
        players.push(payable(msg.sender));
    }

    /// @notice returns a random number
    /// @dev we use internal so that it can only be called from the contract
    /// @dev we use view since were only reading data from the contract
    /// @dev this function will be exculded from the abi 
    /// @return a random unit256 number
    function random() internal view returns(uint256) { 
        return unit256(keccak256(abi.encodePacked(block.difficulty, now(), players.length)));
    }

    /// @notice picks the winner of the lottery
    /// @dev we use the onlyOwner modifier to ensure only the contract owner can select a winner
    /// @dev the modifier is given to us from @openzeppelin
    /// @dev once the winner is selcted we pay them and then reset the game
    function pickWinner() public onlyOwner {
        require(players.length >= 3, "Not enough players");
        winner = players[random() % players.length];
        winner.transfer(getBalance());
        resetLottery();
    }

    /// @notice returns the balance of the contract
    /// @dev we use view since were not modifing data, only returing it
    /// @return the balance of the contract
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }

    /// @notice resets the lottery
    /// @dev clears players from the list
    function resetLottery() internal {
        players = new address payable[](0);
    }
}