#!/bin/bash
echo " Deploying ETH contracts"
cd /home/anand/BC/Public-Contracts/contracts
truffle compile 
truffle migrate --network development
cd ..
echo "deployment of Fabric Contracts"

