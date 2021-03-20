// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

interface IMarket {

    function initialize() external;
    function newRental(address _newOwner, uint256 _newPrice, uint256 _timeLimit, uint256 _tokenId) external;
    function exit(address owner, uint256 tokenID, bool exitFlag) external;

}