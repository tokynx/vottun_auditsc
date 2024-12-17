//Audit:
//1. Redundant Owner Variable: Remove private address owner; since Ownable already provides the owner() function.
//2. Unrestricted Withdrawals: Restrict access to withdrawTips() to only the owner by using the onlyOwner modifier.
//3. Missing Fallback Function: Add a receive() function to handle Ether sent directly to the contract.
//4. Use call() instead of send(): Replace send() with call() for safer Ether transfers.

//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SendMeATip is Ownable {
    event NewTip(address indexed tipper, string name);

    private address owner; // Redundant, remove this line since Ownable already provides an `owner()` function

    struct Tip {
        address tipper;
        string name;
        uint256 value;
    }

    Tip[] Tips;

    constructor() Ownable(msg.sender) {
        // Ownable already sets the owner, no need for this redundant line
    }

    // Fetches all stored Tips (for everyone to see)
    function getTips() public view returns (Tip[] memory) {
        return Tips;
    }

    // Allows users to give a tip to the owner in ETH
    function giveTip(string memory _name) public payable {
        require(msg.value > 0, "cannot buy coffee for free!");

        Tips.push(Tip(msg.sender, _name, msg.value));

        emit NewTip(msg.sender, _name);
    }

    // Allows the owner to withdraw all stored tips in the contract
    function withdrawTips() public {
        require(owner().send(address(this).balance)); // This can be called by anyone, should be restricted to only the owner
    }
}
