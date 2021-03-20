// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IMarket.sol";

contract Factory is Ownable, Initializable {

    address referenceMarket;
    address referenceCard;

    constructor(address _referenceMarket, address _referenceCard){
        referenceMarket =_referenceMarket;
        referenceCard = _referenceCard;

    }

    function initialize() external initializer {}

    function createMarket(uint256 _numberOfCards, uint256 marketFinishTime) external onlyOwner {
        address _marketAddress = Clones.clone(referenceMarket);
        IMarket _marketInstance = IMarket(_marketAddress);
        _marketInstance.initialize(referenceCard,_numberOfCards,marketFinishTime);

    }

}