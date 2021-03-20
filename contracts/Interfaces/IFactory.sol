// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

interface IFactory {
    function initialize() external;
    function createMarket(uint256 _numberOfCards, uint256 marketFinishTime) external ;
    function setAddresses(address _referenceMarket, address _referenceCard, address _sfHost, address _sfAgreements, address _daiSuperToken) external ;
  
}