// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Reveal is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    bool private revealed = false;
    string private revealUrl = "https://ipfs.io/ipfs/{cid}/notRevealed.json";

    constructor() ERC721("Reveal", "RVL"){}

    function awardItem(address _player, string memory _tokenURI) public returns (uint256) { 
        _tokenId.increment();
        uint256 newItemId = _tokenId.current();
        _mint(_player, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        return newItemId;
    }

    function tokenURI(uint256 _tokenId) publiv view virtual override returns (string memory) {
        if(revealed == true) {
            return super.tokenURI(tokenId);
        } else {
            return revealUrl;
        }
    }
}