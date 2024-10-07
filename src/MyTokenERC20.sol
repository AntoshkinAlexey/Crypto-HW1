// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";


contract MyTokenERC20 is ERC20 {
    address public owner;
    uint256 public buyPrice = 100 ether; // Цена токена в wei.

    /**
     * @dev Устанавливает начальное количество токенов и владельца контракта.
     */
    constructor() ERC20("MyTokenERC20", "MT20") {
        _mint(msg.sender, 100); // Начальная эмиссия токенов.
        owner = msg.sender;
    }

    /**
     * @dev Перевод токенов с комиссией 1%.
     * @param to Адрес получателя токенов.
     * @param value Количество токенов для перевода.
     * @return bool Статус операции.
     */
    function transfer(address to, uint256 value) public override returns (bool) {
        uint256 fee = value / 100; // Комиссия 1%
        require(balanceOf(msg.sender) >= value, "Insufficient balance");
        _transfer(msg.sender, owner, fee); // Отправляем комиссию владельцу.
        _transfer(msg.sender, to, value - fee); // Отправляем оставшуюся сумму получателю.
        return true;
    }

    /**
     * @dev Перевод токенов с разрешённого аккаунта с комиссией 1%.
     * @param from Адрес, с которого будут переведены токены.
     * @param to Адрес получателя токенов.
     * @param value Количество токенов для перевода.
     * @return bool Статус операции.
     */
    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        address spender = _msgSender();
        uint256 fee = value / 100; // Комиссия 1%
        require(balanceOf(from) >= value, "Insufficient balance");
        _spendAllowance(from, spender, value);
        _transfer(from, owner, fee); // Отправляем комиссию владельцу.
        _transfer(from, to, value - fee); // Отправляем оставшуюся сумму получателю.
        return true;
    }

    /**
     * @dev Позволяет пользователю купить токены за ETH.
     */
    function buy() public payable {
        require(msg.value > 0, "Must send ETH to buy tokens");
        uint256 tokensToTransfer = msg.value / buyPrice;
        require(balanceOf(owner) >= tokensToTransfer, "Not enough tokens available");
        _transfer(owner, msg.sender, tokensToTransfer);
    }
}