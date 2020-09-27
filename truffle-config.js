require('dotenv').config()
const HDWalletProvider = require('@truffle/hdwallet-provider');
const kovanUrl = process.env.KOVAN_URL;
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();
const NonceTrackerSubprovider = require("web3-provider-engine/subproviders/nonce-tracker")

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "5777"
    },
    kovan: {
      provider: function() {
        var wallet = new HDWalletProvider(mnemonic, kovanUrl);
        var nonceTracker = new NonceTrackerSubprovider()
        wallet.engine._providers.unshift(nonceTracker)
        nonceTracker.setEngine(wallet.engine)
        return wallet
      },
      network_id: 42
    }
  },
  mocha: {
  },
  compilers: {
    solc: {
      version: "0.6.6",
    },
  },
};
