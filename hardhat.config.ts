import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-contract-sizer";
import "@uniswap/hardhat-v3-deploy";

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
      // allowUnlimitedContractSize: true,
      // blockGasLimit: 9007199254740990,
      // accounts: {
      //   accountsBalance: "336693040176119404847394056"
      // },
      // forking: {
      //   url: "https://eth-goerli.g.alchemy.com/v2/y-DhDVZMysAkR2ndxXcgapSfDMhFI0_G",
      // }
    },
    localhost: {
      // allowUnlimitedContractSize: true,
      // blockGasLimit: 9007199254740990,
      // forking: {
      //   url: "https://eth-goerli.g.alchemy.com/v2/y-DhDVZMysAkR2ndxXcgapSfDMhFI0_G",
      // }
    },
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/y-DhDVZMysAkR2ndxXcgapSfDMhFI0_G",
      accounts: [fs.readFileSync("./.private", "utf8")]
    }
  }
};

export default config;
