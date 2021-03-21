//require("dotenv").config();

var Factory = artifacts.require("Factory");
var factoryAddress = '0x7ab1f39B4f22a0aC97cEf262f1b30A954B37aDc8'; 

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