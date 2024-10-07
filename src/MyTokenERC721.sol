// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "forge-std/console.sol";

contract MyToken is ERC721, ERC721URIStorage {
    address public owner;
    uint256 public buyPrice = 0.01 ether; // Цена токена в wei.
    uint256 private _tokenUId = 1;

    constructor() ERC721("MyTokenERC721", "MT721") {
        owner = msg.sender;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Создает новый токен и устанавливает URI для него.
     * @param to Адрес получателя токена.
     * @param _tokenURI URI метаданных токена.
     * @return uint256 Идентификатор токена.
     */
    function mintNFT(address to, string memory _tokenURI) public returns (uint256) {
        require(msg.sender == owner, "Only owner can mint tokens");
        _mint(to, _tokenUId);
        _setTokenURI(_tokenUId, _tokenURI);
        _tokenUId += 1;
        return _tokenUId - 1;
    }

    /**
     * @dev Позволяет пользователю купить токен за ETH.
     * @param _tokenURI URI метаданных токена.
     */
    function buy(string memory _tokenURI) public payable {
        require(msg.value >= buyPrice, "Not enough ETH to buy NFT");

        // Создаем новый токен и передаем его покупателю
        uint256 newTokenId = _tokenUId;
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        // Обновляем идентификатор для следующего токена
        _tokenUId += 1;

        console.log("Attempting to send ETH to owner:", owner);
        console.log("Owner balance before transfer:", address(owner).balance);
        console.log("Sent value:", msg.value);

        // Передаем оплату владельцу контракта
        payable(owner).call{value: msg.value}("");
    }
}