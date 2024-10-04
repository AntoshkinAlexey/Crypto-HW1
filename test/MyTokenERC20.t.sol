// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyTokenERC20.sol";

contract MyTokenERC20Test is Test {
    MyTokenERC20 token;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        owner = address(this);
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        token = new MyTokenERC20();
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 100, "Initial supply is incorrect");
    }

    function testTransferWithFee() public {
        uint256 transferAmount = 10;
        uint256 fee = transferAmount / 100;

        token.transfer(user1, transferAmount);

        assertEq(token.balanceOf(user1), transferAmount - fee, "Incorrect balance for user1 after transfer");
        assertEq(token.balanceOf(owner) + transferAmount - fee, token.totalSupply(), "Incorrect fee balance for owner");
    }

    function testApproveAndTransferFrom() public {
        uint256 approveAmount = 20;
        uint256 transferAmount = 10;
        uint256 fee = transferAmount / 100;

        token.approve(user1, approveAmount);
        vm.prank(user1);
        token.transferFrom(owner, user2, transferAmount);

        assertEq(token.balanceOf(user2), transferAmount - fee, "Incorrect balance for user2 after transferFrom");
        assertEq(token.balanceOf(owner) + transferAmount - fee, token.totalSupply(), "Incorrect fee balance for owner after transferFrom");
        assertEq(token.allowance(owner, user1), approveAmount - transferAmount, "Allowance was not updated correctly");
    }

    function testBuyTokens() public {
        uint256 ethAmount = token.buyPrice() * 5; // Покупаем 5 токенов.
        vm.deal(user1, ethAmount);
        vm.prank(user1);
        token.buy{value: ethAmount}();
        assertEq(token.balanceOf(user1), 5 , "Incorrect token balance after buy");
        assertEq(token.balanceOf(owner) + 5, token.totalSupply(), "Incorrect balance for owner after buy");
    }

    function testFailBuyTokensInsufficientTokens() public {
        uint256 buyPrice = token.buyPrice();
        uint256 ethAmount = buyPrice * 200; // Пытаемся купить больше, чем есть у владельца.

        vm.deal(user1, ethAmount);
        vm.prank(user1);
        token.buy{value: ethAmount}();
    }

    function testFailTransferWithoutSufficientBalance() public {
        vm.prank(user1);
        token.transfer(user2, 50); // Попытка перевода без достаточного баланса.
    }
}