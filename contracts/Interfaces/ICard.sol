// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

interface ICard {

    function closeMarket() external;
    function timeHeld(address) external;
    function totalTimeHeld() external;


}