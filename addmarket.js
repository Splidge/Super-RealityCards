//require("dotenv").config();

var Factory = artifacts.require("Factory");
var factoryAddress = '0xD78015920c7bE02d21cD3fd14ED43EA2b2d6218f'; 

module.exports = function() {
  async function createMarket() {
    // create market
    let factory = await Factory.at(factoryAddress);
    console.log("CREATING MARKET");
    var transaction = await factory.createMarket(3, 2616079600);

    var lastAddress = await factory.mostRecentMarket.call(0);
    console.log("Market created at address: ", lastAddress);
    console.log("Block number: ", transaction.receipt.blockNumber);
    process.exit();
  }
  createMarket();
};