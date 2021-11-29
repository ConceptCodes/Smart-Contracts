// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./SimpleStorage.sol"; // you want to keep both files in the same directory


contract StorageFactory is SimpleStorage {
    SimpleStorage[] public _storage;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        _storage.push(simpleStorage);
    }

    function sfStore(uint256 _index, uint256 _num) public {
        // Address

        // ABI
        SimpleStorage(address(_storage[_index])).store(_num);
    }

    function sfGet(uint256 _index) public view returns(uint256) {
        return SimpleStorage(address(_storage[_index])).retrieve();
    }
}