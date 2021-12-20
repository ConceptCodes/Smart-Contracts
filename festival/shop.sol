// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./token.sol";
import "./ticket.sol";

contract Shop {
    Token private _token;
    Ticket private _ticket;
    uint256 private _ogTicketPrice;
    uint256 public constant commision = 5;

    struct TicketInfo {
        uint256 lastSellPrice;
        uint256 salePrice;
    }

    mapping(uint256 => TicketInfo) private _ticketInfo;
    uint256[] private _tokenIds;

    constructor(Token token, Ticket ticket) public {
        require(ticket.getTicketTotal() == 0, "");
        _token = token;
        _ticket = ticket;
        _ogTicketPrice = ticket.getOriginalPrice();
    }

    function _buyTicket(address _guest) public returns(uint256) {
        require(_ticket.ticketsAvailable());
        if(!_token.transferFrom(msg.sender, address(this), _ogTicketPrice))) {
            revert();
        } 
        uint256 tokenId = _ticket.mint(_guest)
        _ticketInfo[tokenId] = TicketInfo({
            lastSellPrice: _ogTicketPrice,
            salePrice: 0
        });
        _tokenIds.push(tokenId);
        return tokenId;
    }

    function buyTicket() public returns(uint256) {
        return _buyTicket(msg.sender);
    }

    function _resaleTicket(uint256 tokenId, uint256 price) public {
        require(_ticketInfo[tokenId].lastSellPrice != uint256(0), "Cant sell a ticket for $0");
        require(_ticket.ownerOf(tokenId) == msg.sender, "Cannot sell a ticket you don't own");
        require(price <= 11 * _ticketInfo[tokenId].lastSellPrice / 10, "");
        _ticketInfo[tokenId].salePrice = price;
    }

    function resaleTicket()
}

