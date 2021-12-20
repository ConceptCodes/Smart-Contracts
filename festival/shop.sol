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

    function buyTicket() public returns(uint256) {
        require(_ticket.ticketsAvailable());
        if(!_token.transferFrom(msg.sender, address(this), _ogTicketPrice))) {
            revert();
        } 
        uint256 tokenId = _ticket.mint(msg.sender)
        _ticketInfo[tokenId] = TicketInfo({
            lastSellPrice: _ogTicketPrice,
            salePrice: 0
        });
        _tokenIds.push(tokenId);
        return tokenId;
    }

    function _resaleTicket(uint256 tokenId, uint256 price) public {
        require(_ticketInfo[tokenId].lastSellPrice != uint256(0), "Cant sell a ticket for $0");
        require(_ticket.ownerOf(tokenId) == msg.sender, "Cannot sell a ticket you don't own");
        require(price <= 11 * _ticketInfo[tokenId].lastSellPrice / 10, "");
        _ticketInfo[tokenId].salePrice = price;
    }

    function resaleTicket(uint256 tokenId, address _guest) public {  
        require(_ticketInfo[tokenId].salePrice != uint256(0), "Ticket must be for sale");
        address owner = ticket.ownerOf(tokenId);
        uint256 price = _ticketInfo[tokenId].salePrice;
        require(_token.allowance(msg.sender, address(this)) >= price, "");
        if(!(_token.transferFrom(msg.sender, address(this), price * commision / 100))) {
            revert();
        }
        if(!(_token.transferFrom(msg.sender, owner, price * (100 - commision) / 100))) {
            revert();
        }
        _ticket.safeTransferFrom(owner, _guest, tokenId);
        _ticketInfo[tokenId].lastSellPrice = _ticketInfo[tokenId].salePrice;
        _ticketInfo[tokenId].salePrice = 0;
    } 

    function getOriginalPrice() external view returns(uint256) {
        return _ogTicketPrice;
    }

    function getTicketsSold() external view returns(uint256[] memory) {
        return _tokenIds;
    }

    function getLastSellPrice(uint256 _id) external view returns(uint256) {
        return _ticketInfo[_id].lastSellPrice;
    }

    function getForSalePrice(uint256 _id) external view returns(uint256) {
        return _ticketInfo[_id].salePrice;
    }
}

