// SPDX-License-Identifier: MIT

pragma solidity ^0.5.8;

import "./BasicStorage.sol";

contract BasicStorageFactory {
    address[] public addresses;

    function createStorage() external {
        address basicStorageAddress = address(new BasicStorage());
        addresses.push(basicStorageAddress);
    }

    function setData(uint _index, string calldata _data) external {
        require(_index < addresses.length, "this _index does not exist");
        BasicStorage tmp = BasicStorage(addresses[_index]);
        tmp.setData(_data);
    }

}