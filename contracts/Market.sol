// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Initializable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "/interfaces/ICard.sol";

contract Market is Ownable, Initializable {

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

    address[] cards;

    constructor(){}

    function initialize(address _cardReference, uint256 _numberOfCards) external initializer {
        // clone the cards, add them to the array and init them
        for(uint256 i; i < _numberOfCards; i++){
            address _card = Clones.clone(_cardReference);
            cards[i] = _card;
            ICard _cardInstance = ICard(card);
            _cardInstance.initialize();
        }

    }

    function newRental(address _newOwner, uint256 _newPrice, uint256 _timeLimit, uint256 _tokenId) external {
        LogNewRental(_newOwner, _newPrice, _timeLimit, _tokenId);
    }

    function exit(address owner, uint256 tokenID, bool exitFlag) external {
        LogExit(owner, tokenId, exitFlag);
    }


}