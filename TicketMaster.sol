// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract TicketMaster {
    address owner;
    uint256 price = 0.01 ether;
    mapping(address => uint256) public ticketHolders;

    constructor() {
        owner = msg.sender;
    }

    /**
        @dev lets guest purchase tickets
     */
    function buyTickets(address _guest) payable public {
        require(msg.value >= price);
        addTicket(_guest, 1);
    }

    /**
        @dev lets guest use their ticket
    */

    function useTicket(address _guest) public {  
        removeTicket(_guest, 1);
    }

    /**
        @dev adds tickets to guest
     */
    function addTicket(address _guest, uint256 _amt) internal {
        ticketHolders[_guest] = ticketHolders[_guest] + _amt;
    }

    /**
        @dev remove tickets from user
     */
    function removeTicket(address _guest, uint256 _amt) internal {
        require(ticketHolders[_guest] >= _amt, "You do not have enough tickets");
        ticketHolders[_guest] = ticketHolders[_guest] - _amt;
    }

    /**
        @dev allows onwer to withdraw balance
     */
    function withdraw() public {
        require(msg.sender == owner, "You are not the owner"); // double check that your the owner
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success);
    }
}