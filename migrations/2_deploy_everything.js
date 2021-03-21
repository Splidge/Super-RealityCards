var Factory = artifacts.require('./Factory.sol');
var NFTHub = artifacts.require('./NFTHub.sol');

var sfHostGoerli = '0x22ff293e14F1EC3A09B137e9e06084AFd63adDF9'; //  Goerli
var sfAgreementGoerli = '0xEd6BcbF6907D4feEEe8a8875543249bEa9D308E8'; // Goerli
var fDAIxGoerli = '0xF2d68898557cCb2Cf4C10c3Ef2B034b2a69DAD00'; // Goerli

var sfHostRopsten = '0xF2B4E81ba39F5215Db2e05B2F66f482BB8e87FD2'; //  Ropsten
var sfAgreementRopsten = '0xaD2F1f7cd663f6a15742675f975CcBD42bb23a88'; // Ropsten
var fDAIxRopsten = '0xBF6201a6c48B56d8577eDD079b84716BB4918E8A'; // Ropsten

// JavaScript export
module.exports = function(deployer, network, accounts) {
    // Deployer is the Truffle wrapper for deploying
    // contracts to the network
    // deployer.deploy(Card);
    // Deploy the contract to the network

    if (network === "ropsten") 
    {
        deployer.deploy(NFTHub).then(function() {
        return deployer.deploy(Factory,sfHostRopsten,sfAgreementRopsten,fDAIxRopsten,NFTHub.address);
        })
    } 
    else if (network === "goerli")  
    {
        deployer.deploy(NFTHub).then(function() {
        deployer.deploy(Factory,sfHostGoerli,sfAgreementGoerli,fDAIxGoerli,NFTHub.address);
        })
    }
    else if (network === "development")  
    {
        deployer.deploy(NFTHub).then(function() {
        deployer.deploy(Factory,sfHostGoerli,sfAgreementGoerli,fDAIxGoerli,NFTHub.address);
        })
    }

    // console.log('Factory ', Factory.address);
    // console.log('ReferenceMarket ', Market.address);
    // console.log('ReferenceCard ', Card.address);
}
