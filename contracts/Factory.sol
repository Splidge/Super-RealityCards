// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IMarket.sol";

contract Factory is Ownable, Initializable {

    constructor(){}

    function initialize(address _cardReference, uint256 _numberOfCards, uint256 _marketFinishTime) external initializer {
   
    }

}