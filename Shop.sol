// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title A smart contract for shop owners
/// @author Concept
/// @notice allows customers to buy items and get refunds
/// @dev implements basic guard checks
contract Shop {
    uint256 private basePrice = 1 ether;
    mapping(string => uint256) items;
    mapping(address => string) customerPurchases;
    address private customer = msg.sender;

    event ItemSold(address indexed _from, uint256 cost);

    constructor() {
        items["plain"] = basePrice;
        items["deluxe"] = basePrice * 2;
    }

    /// @dev ensures customer has enough funds to purchase item
    modifier hasEnoughFunds(string calldata _item) {
        require(msg.value >= items[_item], "Not enough to buy item");
        _;
    }

    /// @dev if item price is 0 then its safe to assume that item doesnt exist
    modifier doesItemExist(string calldata _item) {
        require(items[_item] > 0, "Sorry that item doesnt exist");
        _;
    }

    /// @dev ensures customer is eligible for refund
    modifier itemHasBeenPurchased(string calldata _item) {
        require(keccak256(abi.encodePacked(customerPurchases[customer])) == keccak256(abi.encodePacked(_item)), "You haven't bought that item");
        _;
    }

    /// @notice Displays the price of your selected item
    /// @dev checks if item exist, if so then return the price
    /// @param _item that your fetching the price for
    /// @return price of a given item
    function getItemPrice(string calldata _item) public view doesItemExist(_item) returns(uint256) { 
        return items[_item];
    }

    /// @notice Allows you to buy items
    /// @param _item item you would like to purchase
    /// @dev Checks if value sent is greater than or equal to the cost of the item, if so then emit an item sold event
    function buyItem(string calldata _item) payable public doesItemExist(_item) hasEnoughFunds(_item) {
        customerPurchases[customer] = _item;
        emit ItemSold(customer, msg.value);
    }

    /// @notice Allows customer to receive a refund 
    /// @param _item item you want a refund for
    /// @dev checks what item the cusotomer has bought and returns that amount to them
    /// @return true if refund was successful
    function refund(string calldata _item) public itemHasBeenPurchased(_item) returns(bool) {
        (bool success, ) = payable(customer).call{value: items[_item]}("");
        return success;
    }

    /// @notice Display the balance of the smart contract
    /// @return The Balance of the smart contract
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}