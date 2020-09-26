# Overview
A Conflict Condensed Consensus Algorithm Conserved on Chainlink Initiators and Adaptors

# Theory
Tussle is a consensus algorithm for conflict condensed consensus situations.

# Examples
Tussle between Trading Agents
Tussle between Tracking Devices
Tussle between Tyrants in Society

# Lifecycle
* Conflict Condensation phase
* Conflict Resolution phase
* Conflict Annotation phase
* Conflict Conservation phase
* Conflict conjugation phase

## Requirements
* NodeJS
* NPM
* Truffle

## Installation
* Package installation should have occurred for you during the Truffle Box setup. 
* However, if you add dependencies, you'll need to add them to the project by running:

* npm install Or
* yarn install

## Testing 
* npm test

## Deploy

If needed, edit the truffle-config.js config file to set the desired network to a different port. It assumes any network is running the RPC port on 8545.

* npm run migrate:dev

For deploying to live networks, Truffle will use truffle-hdwallet-provider for your mnemonic and an RPC URL. 
Set your environment variables $RPC_URL and $MNEMONIC before running:

* npm run migrate:live
