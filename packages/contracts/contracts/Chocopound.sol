// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract RoyalityBox is ERC721 {
    mapping(uint256 => uint256) public royaltyRatios;
    mapping(uint256 => uint256) public prices;

    uint256 constant BASE_RATIO = 10000;

    string public baseURI;
    address public boxOwnership;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory baseURI_
    ) ERC721(_name, _symbol) {
        baseURI = baseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function owner() public view virtual returns (address) {
        return ownerOf(0);
    }

    function deliveryBox(
        address payable _creator,
        uint256 _royaltyRatio,
        uint256 _price
    ) public {
        bytes32 hash = keccak256(abi.encodePacked(block.chainid, address(this), _creator, _price, _royaltyRatio));
        uint256 tokenId = uint256(hash);
    }

    function refundBox() public {}
}
