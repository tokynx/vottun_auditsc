// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SendMeATip is Ownable {
    event NewTip(address indexed tipper, string name);

    struct Tip {
        address tipper;
        string name;
        uint256 value;
    }

    Tip[] public tips;

    constructor() Ownable() {}

    /**
     * @dev give a tip to the owner in ETH
     * @param _name name of the tipper
     */
    function giveTip(string memory _name) external payable {
        require(msg.value > 0, "Cannot send zero value tip!");

        tips.push(Tip(msg.sender, _name, msg.value));

        emit NewTip(msg.sender, _name);
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner()).transfer(balance);
    }

    // Fallback function to reject incoming Ether
    receive() external payable {
        revert("Contract does not accept Ether directly");
    }
}
