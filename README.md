# Santa's Proxy Puzzle: A Blockchain Chimney Challenge

## Description to be used in Challenge
Unwrap a festive smart contract vulnerability where storage regions become your playground and holiday cheer meets digital mischief. Ho ho ho... or is it hax hax hax?
Vulnerability Description

## Technical Details
The challenge exploits a critical vulnerability in an Ethereum proxy contract through strategic storage manipulation:

Proxy contract stores implementation and admin addresses in special sotrage slots.
The `Wallet3.sol` contract contains a dynamic bytes32 array positioned near these critical storage slots.
Reentrancy attack vector allows overwriting the implementation address adding notes to the `Wallet3.sol` contract and override the implementation address in the proxy.
This allows an attacker to take over the proxy contract completely and drain it.

To see an example exploit look at the `Attacker.sol` contract.

To make it a little harder Santa switches the used Wallet implementation between every 10 and 40 seconds to the next in line.

## Setup
Just build and run the docker container with port 8080 exposed.

## Disclaimer
Educational purpose only. Do not use on mainnet.