require('dotenv').config()
const HDWalletProvider = require('@truffle/hdwallet-provider');
const kovanUrl = process.env.KOVAN_URL;
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();
const NonceTrackerSubprovider = require("web3-provider-engine/subproviders/nonce-tracker")

module.exports = {
  networks: {
    
    cldev: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    
    ganache: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '1601194398809',
    },
    
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
    
    live: {
      provider: () => {
        return new HDWalletProvider(process.env.MNEMONIC, process.env.RPC_URL)
      },
      network_id: '*',
      // ~~Necessary due to https://github.com/trufflesuite/truffle/issues/1971~~
      // Necessary due to https://github.com/trufflesuite/truffle/issues/3008
      skipDryRun: true,
    },
    
  },
  mocha: {
  },
  compilers: {
    solc: {
      version: "0.6.6",
    },
  },
};
