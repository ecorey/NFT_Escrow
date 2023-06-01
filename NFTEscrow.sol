// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTandETHescrow {
    address payable public buyer;
    address payable public seller;
    uint256 public nftTokenId;
    IERC721 public nftContract;
    uint256 public ethAmount;
    bool public buyerDeposited;
    bool public sellerDeposited;

    constructor(
        address payable _buyer,
        address payable _seller,
        address _nftContract,
        uint256 _nftTokenId,
        uint256 _ethAmount
    ) {
        buyer = _buyer;
        seller = _seller;
        nftContract = IERC721(_nftContract);
        nftTokenId = _nftTokenId;
        ethAmount = _ethAmount;
    }

    function buyerDeposit() external payable {
        require(msg.sender == buyer, "Only the buyer can deposit ETH.");
        require(msg.value == ethAmount, "Invalid amount sent.");
        require(!buyerDeposited, "Buyer has already deposited.");
        buyerDeposited = true;
    }

    function sellerDeposit() external {
        require(msg.sender == seller, "Only the seller can deposit NFT.");
        require(!sellerDeposited, "Seller has already deposited.");
        nftContract.transferFrom(seller, address(this), nftTokenId);
        sellerDeposited = true;
    }

    function releaseFunds() external {
        require(buyerDeposited && sellerDeposited, "Both parties must deposit.");
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can release funds.");
        nftContract.transferFrom(address(this), buyer, nftTokenId);
        seller.transfer(ethAmount);
    }

    function cancel() external {
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can cancel.");
        if (buyerDeposited) {
            buyer.transfer(ethAmount);
        }
        if (sellerDeposited) {
            nftContract.transferFrom(address(this), seller, nftTokenId);
        }
    }
}


// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,  0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xd9145CCE52D386f254917e481eB44e9943F39138,  0, 40000000000000000000