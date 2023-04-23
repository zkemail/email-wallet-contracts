import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-contract-sizer";
import * as fs from "fs";
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1,
      },
    },
  },
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      blockGasLimit: 9007199254740990,
      accounts: {
        accountsBalance: "16013158298274580703223840"
      },
      forking: {
        url: "https://eth-mainnet.g.alchemy.com/v2/evLf9X8p1aPGZ0bTG4SaoSzCTzyQ7b-B",
        blockNumber: 8876432
      }
    },
    localhost: {
      allowUnlimitedContractSize: true,
      blockGasLimit: 9007199254740990,
      forking: {
        url: "https://eth-mainnet.g.alchemy.com/v2/evLf9X8p1aPGZ0bTG4SaoSzCTzyQ7b-B",
        blockNumber: 8876432
      }
    },
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/y-DhDVZMysAkR2ndxXcgapSfDMhFI0_G",
      accounts: [fs.readFileSync("./.private", "utf8")]
    }
  }
};

export default config;
