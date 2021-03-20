// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

interface Factory {
    function initialize() external;
    function createMarket() external;
}