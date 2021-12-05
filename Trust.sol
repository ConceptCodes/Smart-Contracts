// SPDX-License-Identifier: MIT

/**
    @title Family Trust Smart Contract
 */
contract Trust { 
    struct Kid { 
        uint amt;
        uint maturity;
        bool paid;
    }

    mapping(address => Kid) public children;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function addChild(address _child, uint _timeToMaturity) external payable {
        require(msg.sender == admin, 'only the admin is allowed to add children');
        require(children[_child].amt == 0, 'child already exists');
        children[_child] = Kid(msg.value, block.timestamp + _timeToMaturity, false);
    }

    function withdraw() external {
        Kid storage kid = children[msg.sender];
        require(kid.amt > 0, 'only child can withdraw');
        require(kid.maturity <= block.timestamp, 'too early');
        require(kid.paid == false, 'paid already');
        kid.paid = true;
        payable(msg.sender).transfer(kid.amt);
    }
}