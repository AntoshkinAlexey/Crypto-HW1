// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyTokenERC20.sol";
import "../src/MyTokenERC721.sol";
import "../src/MyTokenERC1155.sol";

contract DeployTokens is Script {
    function run() external {
        vm.startBroadcast();

        MyTokenERC20 token20 = new MyTokenERC20();
        console.log("MyTokenERC20 deployed to:", address(token20));

        MyTokenERC721 token721 = new MyTokenERC721();
        console.log("MyTokenERC721 deployed to:", address(token721));

        MyTokenERC1155 token1155 = new MyTokenERC1155(msg.sender);
        console.log("MyTokenERC1155 deployed to:", address(token1155));

        vm.stopBroadcast();
    }
}
