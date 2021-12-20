// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./token.sol";

contract Ticket is ERC721, AccessControl {
    using Counter for Counters.Counter;
    bytes32 public constant MINTER = keccak256("MINTER");
    bytes32 public constant PAUSER = keccak256("PAUSER");
    bytes32 public constant TRANSFER = keccak256("TRANSFER");

    Counters.Counter private _tokenIdTracker;
    uint32 private _maxAmount;
    Token private _token;
    uint256 private _initialPrice;

    constructor(Token token, unit256 initialPrice, uint32 maxAmount) ERC721("Ticket Name", "Ticket Price") public {
        require(maxAmount > 0);
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER, _msgSender());
        _setupRole(PAUSER, _msgSender());
        _maxAmount = maxAmount;
        _token = token;
        _initialPrice = initialPrice;
        _setBaseURI("https://url-goes-here.com/ticket/");
    }

    /// @notice prevent transfer unless sender has the transfer role
    /// @dev can only be used by user with transfer role
    /// @param from address of sender
    /// @param to address of reciever
    /// @param id of the tickets
    function _beforeTokenTransfer(address _from, address _to, uint256 _id) internal virtual override {
        super._beforeTokenTransfer(_from, _to, _id); 
        require(hasRole(TRANSFER, _msgSender()), "Tickets can only be transferred by whoever has the transfer role");
    }

    /// @notice mints a new festival ticket
    /// @dev can only be use if user has the minter role
    /// @param to address of person minting ticket
    /// @return id of ticket being minted
    function mint(address _to) public virtual returns(unit256) {
        require(hasRole(MINTER, _msgSender()), "Tickets can only be minted by whoever has minter role");
        require(_tokenIdTracker.current() _maxAmount, "Sorry all tickets have been minted already");
        uint256 tokenId = _tokenIdTracker.current(); 
        _mint(_to, tokenId);
        _tokenIdTracker.increment();
        return tokenId;
    }

    /// @notice the orginal price of the tickets 
    /// @return the initial price 
    function getOriginalPrice() external view returns(unit256) { 
        return _initalPrice;
    }

    /// @notice Total amount of tickets minted currently
    /// @return the total amount of tickets minted
    function getTotalTickets() external view returns(unit256) {
        return _tokenIdTracker;
    }

    /// @notice the token used to purchase the tickets
    /// @return the contract address of the erc20 tokens
    function getToken() external view returns(address) {
        return address(_token);
    }

    /// @notice lets you know if there are tickets still available
    /// @return true if current tickets are less than max tickets
    function ticketsAvailable() external view returns(bool) {
        return _tokenIdTracker.current() <= _maxAmount;
    }
}