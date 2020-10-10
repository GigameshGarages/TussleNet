# Progress
* Integration of Chainlink VRF with RANDAO
* Implementation of Chainlink External Adaptor 
* Implementatio of Linkpool Bridge Adaptor
* Implementation of Chainlink VRF
* Integration of Validator Contracts
* Integration of Proof of Stake Contracts

# Summary
* Chainlink Initiators and Adaptors integrated with Chainlink VRF Powered RANDAO 
* Integration of Validators and Proof of Stake Consensus with Chainlink Oracle Contracts

## Requirements
* Solidity 0.6.6
* Truffle v5.1.46
* NodeJS v14.11
* NPM
* NVM
* Yarn

## Initialization

* npm install truffle -g
* truffle unbox smartcontractkit/box
* yarn install
* npm test
* yar test

## Installation
* Package installation should have occurred for you during the Truffle Box setup. 
* However, if you add dependencies, you'll need to add them to the project by running:

* npm install Or
* yarn install

## Testing 
* npm test

## Deploy

* If needed, edit the truffle-config.js config file to set the desired network to a different port. 
* It assumes any network is running the RPC port on 8545.

* npm run migrate:dev

* For deploying to live networks, Truffle will use truffle-hdwallet-provider for your mnemonic and an RPC URL. 
* Set your environment variables $RPC_URL and $MNEMONIC before running:

* npm run migrate:live

## Roadmap
* Transition to Proof of Stake
* Transition to Automated Market Makers
* Transition to Proof of Reputation
* Develpment of Oracle Contract Witnesses 
