// SPDX-License-Identifier: UNDEFINED
pragma solidity ^0.7.4;
pragma abicoder v2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./interfaces/IMarket.sol";

contract Factory is Ownable {

    address public referenceMarket;
    address public referenceCard;
    address[] public markets;
    address public sfHost;
    address public sfAgreements;
    address public daiSuperToken;
    address public zeroAddress = address(0);

    event LogMarketCreated1(address contractAddress, address treasuryAddress, address nftHubAddress, uint256 referenceContractVersion);
    event LogMarketCreated2(
        address contractAddress,
        uint32 mode,
        string[] tokenURIs,
        string ipfsHash,
        uint32[] timestamps,
        uint256 totalNftMintCount
    );
    event LogMarketApproved(address market, bool hidden);
    event LogAdvancedWarning(uint256 _newAdvancedWarning);
    event LogMaximumDuration(uint256 _newMaximumDuration);

    constructor(address _referenceMarket, address _referenceCard, address _sfHost, address _sfAgreements, address _daiSuperToken){
        referenceMarket =_referenceMarket;
        referenceCard = _referenceCard;
        sfHost = _sfHost;
        sfAgreements = _sfAgreements;
        daiSuperToken = _daiSuperToken;
    }

    function createMarket(uint256 _numberOfCards, uint256 marketFinishTime) external onlyOwner {
        address _marketAddress = Clones.clone(referenceMarket);
        markets.push(_marketAddress);
        IMarket _marketInstance = IMarket(_marketAddress);
        _marketInstance.initialize(referenceCard,_numberOfCards,marketFinishTime);
        string[] memory tokenURIs = new string[](20);
        for(uint256 i; i <_numberOfCards; i++){
            tokenURIs[i] = 'i';
        }
        uint32[] memory timestamps;
        timestamps[0] = uint32(block.timestamp);
        timestamps[1] = uint32(marketFinishTime);
        timestamps[2] = uint32(marketFinishTime);
        uint256 totalNftMintCount = _numberOfCards;
        string memory ipfsHash = '0x0';
        LogMarketCreated1(_marketAddress , zeroAddress, zeroAddress, 1);
        LogMarketCreated2(_marketAddress, 0, tokenURIs, ipfsHash, timestamps, totalNftMintCount);
        LogMarketApproved(_marketAddress, true);
        LogAdvancedWarning(0);
        LogMaximumDuration(uint32(marketFinishTime-block.timestamp));
    }


    function setAddresses(address _referenceMarket, address _referenceCard, address _sfHost, address _sfAgreements, address _daiSuperToken) external onlyOwner {
        // maybe we just use this instead of the constructor?
        referenceMarket =_referenceMarket;
        referenceCard = _referenceCard;
        sfHost = _sfHost;
        sfAgreements = _sfAgreements;
        daiSuperToken = _daiSuperToken;
    }

}