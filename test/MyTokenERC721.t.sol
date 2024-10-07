// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/MyTokenERC721.sol";

contract MyTokenERC721Test is Test {
    MyTokenERC721 token;
    address owner;
    address user1;
    uint256 public buyPrice = 0.01 ether;

    function setUp() public {
        owner = address(this);
        user1 = vm.addr(1);
        token = new MyToken();
    }

    function testMintNFT() public {
        string memory tokenURI = "https://example.com/metadata/1.json";
        uint256 tokenId = token.mintNFT(owner, tokenURI);

        assertEq(token.ownerOf(tokenId), owner, "Owner of minted token is incorrect");
        assertEq(token.tokenURI(tokenId), tokenURI, "Token URI of minted token is incorrect");
    }

    function testBuyNFT() public {
        string memory tokenURI = "https://example.com/metadata/2.json";
        uint256 ethAmount = buyPrice;

        vm.deal(user1, ethAmount);
        vm.prank(user1);
        token.buy{value: ethAmount}(tokenURI);

        uint256 tokenId = 1;
        assertEq(token.ownerOf(tokenId), user1, "Owner of purchased token is incorrect");
        assertEq(token.tokenURI(tokenId), tokenURI, "Token URI of purchased token is incorrect");
    }

    function testFailBuyWithoutEnoughETH() public {
        string memory tokenURI = "https://example.com/metadata/3.json";
        uint256 ethAmount = buyPrice - 1; // Не хватает одного wei

        vm.deal(user1, ethAmount);
        vm.prank(user1);
        token.buy{value: ethAmount}(tokenURI); // Ожидаем, что транзакция завершится с ошибкой
    }

    function testFailMintByNonOwner() public {
        string memory tokenURI = "https://example.com/metadata/4.json";
        vm.prank(user1);
        token.mintNFT(user1, tokenURI); // Ожидаем, что транзакция завершится с ошибкой, так как только владелец может создавать токены
    }
}
