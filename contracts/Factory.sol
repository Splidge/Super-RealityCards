// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Market.sol";

contract Factory is Ownable {

    address[] public markets;
    ISuperfluid public sfHost;
    IConstantFlowAgreementV1 public sfAgreements;
    ISuperToken public daiSuperToken;
    address public zeroAddress = address(0);
    address public NFTHubAddress;
    string[] public tokenURIs;
    address public mostRecentMarket;

    event LogMarketCreated1(address contractAddress, address treasuryAddress, address nftHubAddress, uint256 referenceContractVersion);
    event LogMarketCreated2(
        address contractAddress,
        uint32 mode,
        string[] tokenURIs,
        string ipfsHash,
        uint32[] timestamps,
        uint256 totalNftMintCount,
        address[] cardAddresses
    );
    event LogMarketApproved(address market, bool hidden);
    event LogAdvancedWarning(uint256 _newAdvancedWarning);
    event LogMaximumDuration(uint256 _newMaximumDuration);

    constructor(address _sfHost, address _sfAgreements, address _daiSuperToken, address _NFTHubAddress){
        NFTHubAddress = _NFTHubAddress;
         sfHost = ISuperfluid(_sfHost);
        sfAgreements = IConstantFlowAgreementV1( _sfAgreements);
        daiSuperToken = ISuperToken(_daiSuperToken);
    }

    function createMarket(uint256 _numberOfCards, uint256 marketFinishTime) external {
        Market _market = new Market(_numberOfCards,marketFinishTime, NFTHubAddress, sfHost, sfAgreements, daiSuperToken);
        markets.push(address(_market));
        for(uint256 i ; i < _numberOfCards; i++){
            tokenURIs.push('i');
        }
        uint32[] memory timestamps = new uint32[](3);
        timestamps[0] = uint32(block.timestamp);
        timestamps[1] = uint32(marketFinishTime);
        timestamps[2] = uint32(marketFinishTime);
        uint256 totalNftMintCount = _numberOfCards;
        string memory ipfsHash = '0x0';
        address[] memory cardAddresses = _market.getCards();
        LogMarketCreated1(address(_market) , zeroAddress, zeroAddress, 1);
        LogMarketCreated2(address(_market), 0, tokenURIs, ipfsHash, timestamps, totalNftMintCount, cardAddresses);
        LogMarketApproved(address(_market), true);
        LogAdvancedWarning(0);
        LogMaximumDuration(uint32(marketFinishTime-block.timestamp));
        while (tokenURIs.length > 0){tokenURIs.pop();}
    }


    // function setAddresses(address _sfHost, address _sfAgreements, address _daiSuperToken) external onlyOwner {
    //     // maybe we just use this instead of the constructor?
    //     sfHost = _sfHost;
    //     sfAgreements = _sfAgreements;
    //     daiSuperToken = _daiSuperToken;
    // }

}