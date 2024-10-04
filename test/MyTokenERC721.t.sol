// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/MyTokenERC1155.sol";

contract MyTokenERC1155Test is Test {
    MyTokenERC1155 token;
    address owner;
    address user1;
    uint256 public buyPrice = 0.01 ether;

    function setUp() public {
        owner = address(this);
        user1 = vm.addr(1);
        token = new MyTokenERC1155(owner);
    }

    function testInitialMint() public {
        uint256 balance = token.balanceOf(owner, 1);
        assertEq(balance, 100, "Initial minting of tokens failed");
    }

    function testSetURI() public {
        string memory newUri = "https://example.com/metadata/updated.json";
        token.setURI(newUri);
        string memory uri = token.uri(1);
        assertEq(uri, newUri, "URI not updated correctly");
    }

    function testBuyTokens() public {
        uint256 amountToBuy = 5;
        uint256 ethAmount = amountToBuy * buyPrice;

        vm.deal(user1, ethAmount);
        vm.prank(user1);
        token.buy{value: ethAmount}(amountToBuy);

        uint256 userBalance = token.balanceOf(user1, 1);
        assertEq(userBalance, amountToBuy, "Token buying failed");

        uint256 ownerBalance = token.balanceOf(owner, 1);
        assertEq(ownerBalance, 100 - amountToBuy, "Owner balance did not decrease correctly");
    }

    function testFailBuyWithoutEnoughETH() public {
        uint256 amountToBuy = 5;
        uint256 ethAmount = (amountToBuy * buyPrice) - 1; // Не хватает одного wei

        vm.deal(user1, ethAmount);
        vm.prank(user1);
        token.buy{value: ethAmount}(amountToBuy);
    }

    function testSetTokenURI() public {
        string memory newTokenURI = "https://example.com/metadata/new.json";
        token.setTokenURI(1, newTokenURI);
        string memory updatedURI = token.uri(1);
        assertEq(updatedURI, newTokenURI, "Token URI was not updated correctly");
    }

    function testFailSetTokenURIByNonOwner() public {
        string memory newTokenURI = "https://example.com/metadata/new.json";
        vm.prank(user1);
        token.setTokenURI(1, newTokenURI); // Это должно завершиться ошибкой, так как user1 не является владельцем
    }
}
