// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title A smart contract for shop owners
/// @author Concept
/// @notice allows customers to buy items and get refunds
/// @notice NOT PRODUCTION READY
/// @dev implements basic guard checks
contract Shop {
    uint256 private basePrice = 1 ether;
    mapping(string => uint256) items;
    mapping(address => string[]) customerPurchases;
    address private customer = msg.sender;
    
    enum Stage { Shopping, Checkouted }

    Stage public currentStage = Stage.Shopping;

    event ItemSold(address indexed _from, uint256 cost);
    event ItemRefunded(address indexed _from, uint256 cost);

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
        for(uint i = 0; i < customerPurchases[customer].length; i++) {
            if(keccak256(abi.encodePacked(customerPurchases[customer][i])) == keccak256(abi.encodePacked(_item))) {
            } else {
                revert("You haven't bought that item");
            }
            _;
        }
    }

    modifier whichStage(Stage _stage) {
        require(currentStage == _stage);
        _;
    }

    function updateStage(Stage _stage) internal  {
        currentStage = _stage;
    }

    /// @notice Displays the price of your selected item
    /// @dev checks if item exist, if so then return the price
    /// @param _item that your fetching the price for
    /// @return price of a given item
    function getItemPrice(string calldata _item) public view doesItemExist(_item) returns(uint256) { 
        return items[_item];
    }

    /// @notice List all the items you have bought
    /// @dev looks at customer purchases 
    function getItemsBought() public returns(string[] memory) {
        updateStage(Stage.Checkouted);
        return customerPurchases[msg.sender];
    }

    /// @notice Allows you to buy items
    /// @param _item item you would like to purchase
    /// @dev Checks if value sent is greater than or equal to the cost of the item, if so then emit an item sold event
    function buyItem(string calldata _item) payable public doesItemExist(_item) hasEnoughFunds(_item) whichStage(Stage.Shopping) {
        customerPurchases[customer].push(_item);
        emit ItemSold(customer, msg.value);
    }

    /// @notice Allows customer to receive a refund 
    /// @param _item item you want a refund for
    /// @dev checks what item the cusotomer has bought and returns that amount to them
    function refund(string calldata _item) public itemHasBeenPurchased(_item) whichStage(Stage.Checkouted) {
        uint256 currentBalance = address(this).balance;

        require(getBalance() >= items[_item], "Not enough funds");
        (bool success, ) = payable(customer).call{value: items[_item]}("");

        require(success, "refund was unsuccessful");
        assert(getBalance() == currentBalance - items[_item]);

        emit ItemRefunded(customer, items[_item]);
    }

    /// @notice Display the balance of the smart contract
    /// @return The Balance of the smart contract
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
}