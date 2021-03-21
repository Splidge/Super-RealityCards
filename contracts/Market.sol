// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Card.sol";
import "./interfaces/INFTHub.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import {
    ISuperfluid,
    ISuperToken,
    SuperAppBase,
    SuperAppDefinitions
} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperAppBase.sol";
import {
    IConstantFlowAgreementV1
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";

contract Market is Ownable, SuperAppBase {

    using SafeMath for uint256;

    //as
    uint256 numberOfCards;
    uint256 winningOutcome;
    uint256 totalCollected;
    bool marketFinalised;
    mapping(address => bool) public userAlreadyWithdrawn;

    ISuperToken private daiSuperToken;
    ISuperfluid private sfHost;
    IConstantFlowAgreementV1 private sfAgreements;

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

    address public NFTHubAddress;
    address[] public cards;
    mapping (address => uint256) public tokenIds; 
    uint256 public marketFinishTime;
    int96 public MIN_BID_INCREASE = 110000; // 110000 is 10%, there's 3 decimal places precision

    constructor(uint256 _numberOfCards, uint256 _marketFinishTime, address _NFTHubAddress, ISuperfluid _sfHost, IConstantFlowAgreementV1 _sfAgreements, ISuperToken _daiSuperToken) {
        marketFinishTime = _marketFinishTime;
        NFTHubAddress = _NFTHubAddress;
        INFTHub _nftHub = INFTHub(NFTHubAddress);
        sfHost = _sfHost;
        sfAgreements = _sfAgreements;
        daiSuperToken = _daiSuperToken;
        // clone the cards, add them to the array and init them
        for(uint256 i; i < _numberOfCards; i++){
            Card _card = new Card(sfHost, sfAgreements, daiSuperToken, MIN_BID_INCREASE);
            cards.push(address(_card)); 
            tokenIds[address(_card)] = i;
            _nftHub.mint(address(this), _nftHub.totalTokens().add(i));
        }
        numberOfCards = _numberOfCards;
    }


    function newRental(address _newOwner, uint256 _newPrice, uint256 _timeLimit) external {
        INFTHub _nftHub = INFTHub(NFTHubAddress);
        _nftHub.transfer(_nftHub.checkOwnerOf(tokenIds[msg.sender]), _newOwner, tokenIds[msg.sender]);
        LogNewRental(_newOwner, _newPrice, _timeLimit, tokenIds[msg.sender]);
    }

    function exit(address owner) external {
        LogExit(owner, tokenIds[msg.sender], true);
    }

    function declareWinner(uint256 _tokenId) external onlyOwner {
        require(marketFinishTime <= block.timestamp);
        for(uint256 i; i < numberOfCards; i++){
            Card _card = Card(cards[i]);
            _card.closeMarket();
        }
        INFTHub _nftHub = INFTHub(NFTHubAddress);
        totalCollected = _nftHub.checkBalanceOf(address(this));
        winningOutcome = _tokenId;
        marketFinalised = true;
    }

    function withdraw() external {
        require(marketFinalised, "Not finalised");
        require(!userAlreadyWithdrawn[msg.sender], "Already withdrawn");
        Card _card = Card(cards[winningOutcome]);
        uint256 _winnersTimeHeld = _card.timeHeld(msg.sender);
        uint256 _numerator = totalCollected.mul(_winnersTimeHeld);
        uint256 _winningsToTransfer = _numerator.div(_card.totalTimeHeld());
        daiSuperToken.send(msg.sender, _winningsToTransfer, "0");
        userAlreadyWithdrawn[msg.sender] = true;
    }

    function getCards() external view returns(address[] memory){
        return cards;
    }

}