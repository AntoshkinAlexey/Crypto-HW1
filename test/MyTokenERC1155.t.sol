// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/MyTokenERC1155.sol";

contract MyTokenERC1155Test is Test {
    MyTokenERC1155 token;
    address owner = address(0x1);
    address buyer = address(0x2);

    function setUp() public {
        token = new MyTokenERC1155(owner);
    }

    function testInitialBalance() public {
        uint256 balance = token.balanceOf(owner, 1);
        assertEq(balance, 100);
    }

    function testBuy() public {
        uint256 amountToBuy = 10;
        uint256 valueToSend = amountToBuy * token.buyPrice();
        uint256 prevValue = token.balanceOf(buyer, 1);
        vm.deal(buyer, valueToSend);

        vm.startPrank(buyer);
        token.buy{value: valueToSend}(amountToBuy);
        uint256 balance = token.balanceOf(buyer, 1);
        assertEq(balance, prevValue + amountToBuy);
        vm.stopPrank();
    }

    function testFailBuyNotEnoughEth() public {
        vm.startPrank(buyer);
        token.buy{value: 0}(1);
        vm.stopPrank();
    }
}
