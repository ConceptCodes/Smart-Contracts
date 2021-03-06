// SPDX-License-Identifier: MIT 

pragma solidity ^0.6.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() public ERC20("Token Name", "Token Symbol") {
        _setupDecimals(2);
        _mint(msg.sender, 1000000);
    }
}