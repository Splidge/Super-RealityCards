// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

interface IMarket {

    function initialize(address _cardReference, uint256 _numberOfCards, uint256 _marketFinishTime) external;
    function newRental(address _newOwner, uint256 _newPrice, uint256 _timeLimit) external;
    function exit(address owner) external;
    function marketFinishTime() external view returns(uint256);
    function getCards() external returns(address[] memory cards);

}