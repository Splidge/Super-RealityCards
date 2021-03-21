// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

interface INFTHub {

    function mint(address _to, uint256 _tokenId) external;
    function transfer(address _from, address _to, uint256 _tokenId) external;
    function checkOwnerOf(uint256 _tokenId) external view returns(address owner);
    function checkBalanceOf(address _owner) external view returns(uint256 balance);
    function totalTokens() external view returns(uint256);

}
