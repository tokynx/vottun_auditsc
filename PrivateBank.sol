//Audit:
// 1. Reentrancy Attack: Update state before making external calls in the withdraw() function.
// 2. Function Visibility: Change the visibility of getUserBalance() to internal or private.

pragma solidity 0.8.20;

// SPDX-License-Identifier: MIT

contract PrivateBank {
    mapping(address => uint256) private balances;

    // Deposit function, allows users to deposit Ether to the contract
    function deposit() external payable {
        balances[msg.sender] += msg.value; // Should be safe, but reentrancy is a concern
    }

    // Withdraw function, allows users to withdraw Ether from the contract
    function withdraw() external {
        uint256 balance = getUserBalance(msg.sender); // Potential issue with state update order (reentrancy)

        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}(""); // Reentrancy attack vulnerability
        require(success, "Failed to send Ether");

        balances[msg.sender] = 0; // This should be done before transferring Ether to avoid reentrancy
    }

    // Function to get the contract's balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function to get a user's balance
    // Should not be public, change visibility to internal or private
    function getUserBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }
}
