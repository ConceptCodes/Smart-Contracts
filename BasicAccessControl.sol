// SPDX-License-Identifier: MIT

pragma solidity 0.5.8;

contract BasicAccessControl {
    address admin;
    
    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin, "only the admin can use this function");
        _;
    }

    function privateFunction() external onlyAdmin {

    }
}