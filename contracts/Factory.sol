// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IMarket.sol";

contract Factory is Ownable {

    address public referenceMarket;
    address public referenceCard;
    address[] public markets;
    address public sfHost;
    address public sfAgreements;
    address public daiSuperToken;

    constructor(address _referenceMarket, address _referenceCard, address _sfHost, address _sfAgreements, address _daiSuperToken){
        referenceMarket =_referenceMarket;
        referenceCard = _referenceCard;
        sfHost = _sfHost;
        sfAgreements = _sfAgreements;
        daiSuperToken = _daiSuperToken;
    }

    function createMarket(uint256 _numberOfCards, uint256 marketFinishTime) external onlyOwner {
        address _marketAddress = Clones.clone(referenceMarket);
        markets.push(_marketAddress);
        IMarket _marketInstance = IMarket(_marketAddress);
        _marketInstance.initialize(referenceCard,_numberOfCards,marketFinishTime);
    }


    function setAddresses(address _referenceMarket, address _referenceCard, address _sfHost, address _sfAgreements, address _daiSuperToken) external onlyOwner {
        // maybe we just use this instead of the constructor?
        referenceMarket =_referenceMarket;
        referenceCard = _referenceCard;
        sfHost = _sfHost;
        sfAgreements = _sfAgreements;
        daiSuperToken = _daiSuperToken;
    }

}