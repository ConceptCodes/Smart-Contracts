// SPDX-License-Identifier: MIT

pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

contract Collections {
    struct User {
        address userAddress;
        uint256 balance;
    }

    User[] users;

    function getUsers() external returns(address[] memory, uint[] memory) {
        address[] memory userAddresses = new address[](users.length);
        uint[] memory userBalances = new uint[](users.length);
        for (uint i = 0; i < users.length; i++) {
            userAddresses[i] = users[i].userAddress;
            userBalances[i] = users[i].balance;
        }
    }

    function getUsersSimple() external returns(User[] memory) {
        return users;
    }
  
}