// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

interface ICard {

    function initialize(address, address, address, int96) external;

}