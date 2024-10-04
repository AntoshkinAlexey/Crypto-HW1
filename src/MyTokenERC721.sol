// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, ERC721URIStorage {
    address public owner;
    uint256 public buyPrice = 0.01 ether; // Цена токена в wei.
    Counters.Counter private _tokenUId;

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
     * @param tokenURI URI метаданных токена.
     * @return uint256 Идентификатор токена.
     */
    function mintNFT(address to, string memory tokenURI) public returns (uint256) {
        require(msg.sender == owner, "Only owner can mint tokens");
        _tokenUId.increment();
        uint256 id = _tokenUId.current();
        _mint(to, id);
        _setTokenURI(id, tokenURI);
        return id;
    }

    /**
     * @dev Позволяет пользователю купить токен за ETH.
     * @param tokenURI URI метаданных токена.
     */
    function buy(string memory tokenURI) public payable {
        require(msg.value >= buyPrice, "Not enough ETH to buy NFT");
        uint256 tokenId = mintNFT(msg.sender, tokenURI);

        // Передаем оплату владельцу контракта
        _transfer(msg.sender, owner, msg.value);
    }
}