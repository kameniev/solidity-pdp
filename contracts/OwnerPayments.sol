// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract OwnerPayments {
    
    address owner;

    constructor(){
        owner = msg.sender;
    }

    event Paid(address _from, uint _amount, uint _timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not an owner!");
        _;
    }

    receive() external payable {
        pay();
    }
    
    function pay() public payable {
        emit Paid(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(address payable _to) external onlyOwner {
        _to.transfer(address(this).balance);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
}