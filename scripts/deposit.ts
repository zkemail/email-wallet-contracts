import { ethers } from "hardhat";

async function main() {
  const signer = (await ethers.getSigners())[1];
  const Factory = await ethers.getContractFactory("EmailWallet");
  const contractAddress = "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707"
  console.log(contractAddress);
  const value = "2";
  console.log(value);
  const emailAddress = "suegamisora@gmail.com";
  console.log(emailAddress);
  const EmailWallet = await Factory.attach(contractAddress);
  const depositValue = ethers.utils.parseEther(value);
  await EmailWallet.connect(signer).depositETH(emailAddress, { value: depositValue });
  console.log(await EmailWallet.ethBalanceOfUser(emailAddress));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
