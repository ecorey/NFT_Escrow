// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 private _currentTokenId = 0;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mint(address to) public onlyOwner {
        _safeMint(to, _currentTokenId);
        _currentTokenId++;
    }

    function getTokenIdByIndex(uint256 index) public view returns (uint256) {
        require(index < _currentTokenId, "Index out of range");
        return index;
    }
}
