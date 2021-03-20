// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IMarket.sol";

contract Factory is Ownable {

    address referenceMarket;
    address referenceCard;
    address[] markets;

    constructor(address _referenceMarket, address _referenceCard){
        referenceMarket =_referenceMarket;
        referenceCard = _referenceCard;
    }

    function createMarket(uint256 _numberOfCards, uint256 marketFinishTime) external onlyOwner {
        address _marketAddress = Clones.clone(referenceMarket);
        markets.push(_marketAddress);
        IMarket _marketInstance = IMarket(_marketAddress);
        _marketInstance.initialize(referenceCard,_numberOfCards,marketFinishTime);

    }

}