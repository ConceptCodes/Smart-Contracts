// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Utils {
    function groupExecute(uint _argA, uint _argB) external {
        ContractA(0x....).foo(_argA);
        ContractB(0x....).foo(_argB);
    }
}

contract ContractA {
    function foo(uint _arg) external {  

    }
}

contract ContractB {
    function bar(uint _arg) external {

    }
}