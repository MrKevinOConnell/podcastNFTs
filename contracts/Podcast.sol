// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";

contract Podcast is ERC721Royalty, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
   string _contractURI;
   
   uint256 public _numberMinted = 0;
   uint256 public _maxSupply;
  string private _baseTokenURI;
  address private _podcaster;
    uint256 _price;
   constructor(string memory _name, string memory _symbol, string memory _initBaseURI, uint256 _initMaxSupply, uint256 _initPrice, address _initPodcaster) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    setSupply(_initMaxSupply);
    setPrice(_initPrice);
    _setPodcaster(_initPodcaster);
    _setDefaultRoyalty(0xEdd3783e8c7c52b80cfBD026a63C207Edc9CbeE7,1000);
  }
  event mint(address m, uint256 supply);
 function _setPodcaster(address _newPodcaster) public onlyOwner {
        _podcaster = _newPodcaster;
    }
 function contractURI() public view returns (string memory) {
        return _contractURI;
    }
 function setBaseURI(string memory _uri) public onlyOwner {
         _baseTokenURI = _uri;
    }
  function setPrice(uint256 _newPrice) public onlyOwner {
         _price = _newPrice;
    }

  function setSupply(uint256 _supply) public onlyOwner {
         _maxSupply = _supply;
    }

    function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId),".json"))
        : "";
  }

  function makePodcast() public payable {
    require(_numberMinted < _maxSupply, "podcast has sold out!");
    require(msg.value >= _price, 'Must send enough to purchase the podcast snippet');
     // Get the current tokenId, this starts at 0.
    uint newItemId = _tokenIds.current();
    require(msg.sender.balance >= _price, 'You do not have enough to purchase.');
    (bool success, ) = _podcaster.call{value: _price}('');
    require(success, 'Unable to send value: recipient may have reverted');
     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);
    _numberMinted = _numberMinted + 1;
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
     _tokenIds.increment();
    // Increment the counter for when the next NFT is minted.
     emit mint(msg.sender, newItemId);
 
  }
}