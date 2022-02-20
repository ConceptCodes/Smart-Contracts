pragma solidity ^0.8.10;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _id) external;
}

contract DutchAuction {
    uint private constant DURATION = 7 days;

    IERC721 public immutable item;
    uint public immutable itemId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startTime;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        address _item,
        uint _itemId
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        
        require(_startingPrice >= discountRate * DURATION, "startingPrice must be greater than discount rate");

        item = IERC721(_item);
        itemId = _itemId;

        startTime = block.timestamp;
        expiresAt = block.timestamp + DURATION;

    }

    function getPrice() public view returns(uint) { 
        uint timeElapsed = block.timestamp - startTime;
        uint discount = discountRate + timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "auction is over");
        uint price = getPrice();
        require(msg.value >= price, "Not enough funds");
        item.transferFrom(seller, msg.sender, itemId);
        // look into
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        selfdestruct(seller); // deletes contract
    }


    
}