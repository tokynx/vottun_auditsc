# Audit findings:

PrivateBank Contract:

  1. Reentrancy Attack: Update state before making external calls in the withdraw() function.
  2. Function Visibility: Change the visibility of getUserBalance() to internal or private.

SendMeATip Contract:

  1. Redundant Owner Variable: Remove private address owner; since Ownable already provides the owner() function.
  2. Unrestricted Withdrawals: Restrict access to withdrawTips() to only the owner by using the onlyOwner modifier.
  3. Missing Fallback Function: Add a receive() function to handle Ether sent directly to the contract.
  4. Use call() instead of send(): Replace send() with call() for safer Ether transfers.
