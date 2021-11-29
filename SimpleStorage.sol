// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract SimpleStorage {
    uint256 public favNum; // will be initialized to 0

    struct People {
        uint256 favNum;
        string name;
    }

    People public person = People({favNum: 2, name: "concept"});

    People[] public people; //dynamic array becuase we havent set max length

    mapping(string => uint256) public nameToNum; //helps with mapping name to 

    // we use memory so that the data is deleted after execution, replace with storage if data needs to presist
    function addPerson(string memory _name, uint256 _num) public {
        people.push(People({favNum: _num, name: _name}));
        nameToNum[_name] = _num
    }

    function store(uint256 favorite_number) public {  favNum = favorite_number; }

    // we use view because we just want to read from the blockchain, not change the state
    function retrieve() public view returns(uint256) { return favNum; }

}