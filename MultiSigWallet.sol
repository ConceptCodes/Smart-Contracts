//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public minimalOwners;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approvedTransactions;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Sender is not an Owner");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId < transactions.length, "Tx does not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approvedTransactions[_txId][msg.sender], "Tx has already been approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "Tx has already been executed");
        _;
    }

    constructor(address[] memory _owners, uint _minimalOwners) {
        require(_owners.length > 0, "owners required");
        require(_minimalOwners > 0 && _minimalOwners <= _owners.length, 
                "Minimal number of owners not present");
        for(uint i; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
        minimalOwners = minimalOwners;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        }));
        emit Submit(transactions.length - 1);
    }

    function approve(uint _txId)
        external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
            approvedTransactions[_txId][msg.sender] = true;
            emit Approve(msg.sender, _txId);
        }
    
    function _getApprovalCount(uint _txId) private view returns(uint count) {
        for(uint i; i < owners.length; i++) {
            if(approvedTransactions[_txId][owners[i]]) {
                count += 1;
            }
        }
    }

    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= minimalOwners, "less than required approvals");
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;
        transaction.to
    }

}