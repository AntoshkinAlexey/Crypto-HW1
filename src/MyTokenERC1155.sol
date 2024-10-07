// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyTokenERC1155 is ERC1155, Ownable {
    uint256 public buyPrice = 0.01 ether; // Цена токена в wei.
    uint256 public constant TOKEN_ID = 1; // Идентификатор токена

    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {
        _mint(initialOwner, TOKEN_ID, 100, ""); // Начальная эмиссия токенов.
        _setURI("https://example.com/metadata/1.json"); // Установка метаданных для токена
    }

    /**
     * @dev Позволяет пользователю купить токены за ETH.
     * @param amount Количество токенов для покупки.
     */
    function buy(uint256 amount) public payable {
        require(msg.value >= amount * buyPrice, "Not enough ETH to buy tokens");
        require(balanceOf(owner(), TOKEN_ID) >= amount, "Not enough tokens available");

        // Передаем оплату владельцу контракта
        (bool success, ) = payable(owner()).call{value: msg.value, gas: 100000}("");
        require(success, "Transfer failed");

        // Передаем токены покупателю
        _safeTransferFrom(owner(), msg.sender, TOKEN_ID, amount, "");
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }
}