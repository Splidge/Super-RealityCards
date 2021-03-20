var Factory = artifacts.require('./Factory.sol');
var Market = artifacts.require('./Market.sol');
var Card = artifacts.require('./Card.sol');

var sfHost = '0x22ff293e14F1EC3A09B137e9e06084AFd63adDF9'; // host on Goerli
var sfAgreement = '0xEd6BcbF6907D4feEEe8a8875543249bEa9D308E8'; // Goerli
var fDAIx = '0xF2d68898557cCb2Cf4C10c3Ef2B034b2a69DAD00'; // Goerli

// JavaScript export
module.exports = function(deployer, network, accounts) {
    // Deployer is the Truffle wrapper for deploying
    // contracts to the network
    // deployer.deploy(Card);
    // Deploy the contract to the network
    deployer.deploy(Card).then(function() {
    return deployer.deploy(Market).then(function() {
    return deployer.deploy(Factory,Market.address,Card.address,sfHost,sfAgreement,fDAIx);
    })});
    console.log('Factory ', Factory.address);
    console.log('ReferenceMarket ', Market.address);
    console.log('ReferenceCard ', Card.address);
}
