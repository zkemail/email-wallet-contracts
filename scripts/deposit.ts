import { ethers } from "hardhat";

async function main() {
  const signer = (await ethers.getSigners())[0];
  const Factory = await ethers.getContractFactory("EmailWallet");
  const contractAddress = "0x581a2d0Ec59E217aD6f405511f2D26Bbc8d17BC4"
  console.log(contractAddress);
  const value = "0.0002";
  console.log(value);
  const emailAddress = "suegamisora@gmail.com";
  console.log(emailAddress);
  const EmailWallet = await Factory.attach(contractAddress);
  const depositValue = ethers.utils.parseEther(value);
  const tx = await EmailWallet.connect(signer).depositETH(emailAddress, { value: depositValue });
  const receipt = await tx.wait();
  console.log(receipt);
  console.log(await EmailWallet.balanceOfUser(emailAddress, "ETH"));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
