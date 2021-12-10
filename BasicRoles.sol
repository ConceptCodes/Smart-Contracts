// SPDX-License-Identifier: MIT

pragma solidity ^0.5.8;

import "@openzeppelin/contracts/access/Roles.sol";

contract BasicRoles {
    using Roles for Roles.Roles;

    Roles.Role private users;
    Roles.Role private admins;

    constructor() public {
        admins.add(msg.sender); // initial admin
    }

    modifier onlyUser() {
        require(users.has(msg.sender) == true, "must have user role");
        _;
    }

    modifier onlyAdmin() {
        require(admins.has(msg.sender) == true, "must have admin role");
        _;
    }

    function addUser(address _user) external onlyAdmin() {
        users.add(_user);
    }

    function addAdmin(address _admin) external onlyAdmin() {
        admins.add(_admin);
    }

    function removeUser(address _user) external onlyAdmin() {
        users.remove(_user);
    }

    function removeAdmin(address _admin) external onlyAdmin() {
        admin.remove(_user);
    }

    function userProtectedFn() external onlyUser() {}

    function adminProtectedFn() external onlyAdmin() {}
}