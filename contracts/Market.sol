// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ICard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {
    ISuperfluid,
    ISuperToken,
    SuperAppBase,
    SuperAppDefinitions
} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperAppBase.sol";
import {
    IInstantDistributionAgreementV1
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IInstantDistributionAgreementV1.sol";


import {
    ISuperfluid,
    ISuperToken,
    ISuperAgreement,
    SuperAppDefinitions
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {
    IConstantFlowAgreementV1
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";

import {
    SuperAppBase
} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperAppBase.sol";

contract Market is Ownable, Initializable, ERC721, SuperAppBase {

    ////////////////////////////////////
    //////// EVENTS ////////////////////
    ////////////////////////////////////

    event LogNewRental(address indexed newOwner, uint256 indexed newPrice, uint256 timeHeldLimit, uint256 indexed tokenId);
    event LogForeclosure(address indexed prevOwner, uint256 indexed tokenId);
    event LogRentCollection(uint256 indexed rentCollected, uint256 indexed tokenId, address indexed owner);
    event LogReturnToPreviousOwner(uint256 indexed tokenId, address indexed previousOwner);
    event LogContractLocked(bool indexed didTheEventFinish);
    event LogWinnerKnown(uint256 indexed winningOutcome);
    event LogWinningsPaid(address indexed paidTo, uint256 indexed amountPaid);
    event LogStakeholderPaid(address indexed paidTo, uint256 indexed amountPaid);
    event LogRentReturned(address indexed returnedTo, uint256 indexed amountReturned);
    event LogTimeHeldUpdated(uint256 indexed newTimeHeld, address indexed owner, uint256 indexed tokenId);
    event LogStateChange(uint256 indexed newState);
    event LogUpdateTimeHeldLimit(address indexed owner, uint256 newLimit, uint256 tokenId);
    event LogExit(address indexed owner, uint256 tokenId, bool exit);
    event LogSponsor(uint256 indexed amount);
    event LogNftUpgraded(uint256 indexed currentTokenId, uint256 indexed newTokenId);
    event LogPayoutDetails(address indexed artistAddress, address marketCreatorAddress, address affiliateAddress, address[] cardAffiliateAddresses, uint256 indexed artistCut, uint256 winnerCut, uint256 creatorCut, uint256 affiliateCut, uint256 cardAffiliateCut);
    event LogTransferCardToLongestOwner(uint256 tokenId, address longestOwner);

    ////////////////////////////////////
    //////// VARIABLES /////////////////
    ////////////////////////////////////

    address[] public cards;
    mapping (address => uint256) public tokenIds; 
    uint256 public marketFinishTime;
    address public sfHost;
    address public sfAgreements;
    address public daiSuperToken;
    int96 public MIN_BID_INCREASE = 110000; // 110000 is 10%, there's 3 decimal places precision

    constructor(address _cardReference, uint256 _numberOfCards, uint256 _marketFinishTime) ERC721("SuperRealityCards","SRC") {
        marketFinishTime = _marketFinishTime;
        // clone the cards, add them to the array and init them
        for(uint256 i; i < _numberOfCards; i++){
            address _card = new ICard(sfHost, sfAgreements, daiSuperToken, MIN_BID_INCREASE);
            cards[i] = _card; 
            tokenIds[_card] = i;
            _mint(address(this), i); 
        }
    }

    function newRental(address _newOwner, uint256 _newPrice, uint256 _timeLimit) external {
        _transfer(ownerOf(tokenIds[msg.sender]), _newOwner, tokenIds[msg.sender]);
        LogNewRental(_newOwner, _newPrice, _timeLimit, tokenIds[msg.sender]);
    }

    function exit(address owner) external {
        LogExit(owner, tokenIds[msg.sender], true);
    }

    function declareWinner(uint256 _tokenId) external onlyOwner {
        require(marketFinishTime <= block.timestamp);
        // winner has been decided, make a payout.


    }

}