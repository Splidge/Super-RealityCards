// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTHub is Ownable, ERC721 {

    using SafeMath for uint256;
    uint256 public totalTokens;
    
    constructor() ERC721("SuperRealityCards","SRC") {

    }
    function mint(address _to, uint256 _tokenId) external {
        _mint(_to, _tokenId);
        totalTokens++;
    }
    function transfer(address _from, address _to, uint256 _tokenId) external {
        _transfer(_from, _to, _tokenId);
    }
    function checkOwnerOf(uint256 _tokenId) external view returns(address owner) {
        return ownerOf(_tokenId);
    }
    function checkBalanceOf(address _owner) external view returns(uint256 balance) {
        return balanceOf(_owner);
    }

}
