// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract SvgNFT is ERC721Enumerable, Ownable {
  using Strings for uint256;

  uint256 public cost = 0.001 ether;
  uint256 public maxSupply = 1000;

  constructor() ERC721("<NAME>", "<SYMBOL>") { }

  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= maxSupply);

    if (msg.sender != owner()) {
      require(msg.value >= cost);
    }

    _safeMint(msg.sender, supply + 1);
  }

  function random(uint256 _mod, uint256 _seed, uint256 _salt) public view returns(uint256) {
      return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
  }

  function buildImage() public view returns(string memory) {
      return Base64.encode(bytes(abi.encodePacked(
          '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">',
          '<rect width="500" height="500" fill="hsl(',random(361, 1, 1),', 50%, 25%)" />',
          '<text dominant-baseline="middle" fill="hsl(',random(361, 1, 1),', 100%, 80%)" text-anchor="middle" font-size="41" y="50%" x="50%">ConceptCodes</text>',
          '</svg>'
      )));
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns(string memory) {
    require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
    return string(abi.encodePacked(
        'data:application/json:base64',
        Base64.encode(bytes(abi.encodePacked(
            '{"name":"', "NFT NAME",
            '", "description":"',"DESCRIPTION OF ART",
            '", "image": "','data:image/svg+xml;base64,', buildImage(),
            '"}'
        )))
    ));
  }

  function withdraw() public payable onlyOwner {
      (bool success) = payable(msg.sender).call{value: address(this).balance}("");
      require(success);
  }
}