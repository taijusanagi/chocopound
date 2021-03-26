import * as chai from "chai";
import { solidity } from "ethereum-waffle";
import { ethers } from "hardhat";
import { deployNozei } from "../helpers/migrations";

import { JPYC } from "../typechain";

chai.use(solidity);
const { expect } = chai;

const chainId = 31337;

describe("Chocofactory", function () {
  let signer, nozeiContract, jpcyContract;

  this.beforeEach("initialization.", async function () {
    [signer] = await ethers.getSigners();
    const MockNftContract = await ethers.getContractFactory("JPYC");
    jpcyContract = (await MockNftContract.deploy()) as JPYC;
    const contract = await deployNozei(jpcyContract.address);
    nozeiContract = contract;
  });

  it("nozei deposit", async function () {
    const value = "100000";
    await nozeiContract.connect(signer).deposit({ value });
    expect(await nozeiContract.balanceOf(signer.address)).to.equal(value);
    await nozeiContract.connect(signer).withdraw();
    expect(await nozeiContract.balanceOf(signer.address)).to.equal("0");
  });
});
