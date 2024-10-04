// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract MyTokenERC1155 {
    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    address public owner;
    uint256 public buyPrice = 0.01 ether; // Цена токена в wei.
    uint256 public constant TOKEN_ID = 1; // Идентификатор токена

    constructor() ERC1155("MyTokenERC1155", "MT1155") {
        owner = msg.sender;
        _mint(msg.sender, TOKEN_ID, 100); // Начальная эмиссия токенов.
        _setURI(TOKEN_ID, "https://example.com/metadata/1.json"); // Установка метаданных для токена
    }

    /**
     * @dev Позволяет пользователю купить токены за ETH.
     * @param amount Количество токенов для покупки.
     */
    function buy(uint256 amount) public payable {
        require(msg.value >= amount * buyPrice, "Not enough ETH to buy tokens");
        require(balanceOf(owner, TOKEN_ID) >= amount, "Not enough tokens available");

        _transferFrom(owner, msg.sender, TOKEN_ID, amount);

        // Передаем оплату владельцу контракта
        payable(owner).transfer(msg.value);
    }

    /**
     * @dev Устанавливает URI для токена.
     * @param tokenId Идентификатор токена.
     * @param tokenURI URI метаданных токена.
     */
    function setTokenURI(uint256 tokenId, string memory tokenURI) public {
        require(msg.sender == owner, "Only owner can set token URI");
        _setURI(tokenId, tokenURI);
    }
}
