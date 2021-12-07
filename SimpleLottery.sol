// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0;

contract Lottery {
    mapping(address => uint256) public winnings;
    address[] public tickets;

    uint256 ticketCost = 1 ether;

    string public name = "Lottery";
    string public symbol = "LOT";
    uint256 public maxTickets = 100;
    uint256 public remainingTickets = 0;
    uint public ticketCount = 0;
    uint public randomNum = 0;
    address public latestWinner;

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _maximumTickets)  {
            name = _tokenName;
            symbol = _tokenSymbol;
            maxTickets = _maximumTickets;
            remainingTickets = maxTickets;
        }

    function buy() public payable {
        require(msg.value == ticketCost, 'not enough to purchase ticket');
        uint256 val = msg.value / ticketCost;
        require(remainingTickets - val < remainingTickets, '');
        remainingTickets -= val;

        tickets.push(msg.sender);
        ticketCount++;
    }

    function withdraw() public {
        require(winnings[msg.sender] > 0);
        uint256 amt = winnings[msg.sender];
        winnings[msg.sender] = 0;
        msg.sender.transfer(amt);
    }

    function chooseWinner() public {
        require(ticketCount > 0, 'not enough tickets have been sold');
        randomNum = uint(block.blockhash(block.number-1)) % ticketCount;
        latestWinner = tickets[randomNum];
        winnings[latestWinner] = ticketCount;
        ticketCount = 0;
        remainingTickets = maxTickets;
        delete tickets;
    }
}