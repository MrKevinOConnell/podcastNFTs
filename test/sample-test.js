const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("Podcast");
    const greeter = await Greeter.deploy("Podcast EP","POD","https://gateway.pinata.cloud/ipfs/QmaaKVbdQCQ6RogBDdxSexQfJuYrxL9NGrg4AUh9jgmAZT/",100,2,0xEdd3783e8c7c52b80cfBD026a63C207Edc9CbeE7);
    await greeter.deployed();

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});
