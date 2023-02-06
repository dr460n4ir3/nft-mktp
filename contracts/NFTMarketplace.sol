// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//Internal import for NFT OPENZEPPELIN
import "@openzeppelin/contracts/utils/Counters.sol"; //Counter to keep track of the number of NFTs
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;

    uint256 listingPrice = 0.025 ether; //The price of the NFT you must specify the amount any type ie 0.025 ether

    address payable owner;

    //The following gives the NFT an ID the struct defines the properties of the NFT
    mapping(uint256 => MarketItem) private idToMarketItem;

    struct MarketItem {
        uint256 itemId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool isSold;
    }

    //This triggers the event when an NFT is created
    event MarketItemCreated(
        uint256 indexed itemId,
        address seller,
        address owner,
        uint256 price,
        bool isSold
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    //This defines the name and symbol of the NFT
    constructor() ERC721("NFTMarketplace", "NFTM") {
        owner = payable(msg.sender); //The owner is the person who deployed the contract
    }

    //this function will allow the owner to change the price of the NFT
    function changePrice(uint256 _listingPrice) 
        public 
        payable
        onlyOwner
        
    {   
        require(msg.sender == owner, "Only the owner can change the price");
        listingPrice = _listingPrice;
    }

    // This function will retun the price of the NFT
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }
}