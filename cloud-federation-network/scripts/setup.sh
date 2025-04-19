#!/bin/bash

# setup.sh - hyperledger fabric network Setup


set -e
export FABRIC_CFG_PATH=$(pwd)/configtx
export PATH=$PATH:$(pwd)/bin
CHANNEL_NAME = "mychannel'

echo " creating the channel..."

echo " Step 1 : "Generating Crypto Materials file"

if [ ! -f "crypto-config/crypto-config.yaml"]; then
    echo " ERROR: Crypto-cofig.yaml file not found ( not in ./crypto-config directory )" 
    exit 1

fi
echo " Geenerating crypto materials using cryptogen..."
cryptogen generate --config=crypto-config/crypto-config.yaml --output=organizations
echo " Crypto material stored in ./organizations/ "

echo "Step 2: Generate Genesis Block"
mkdir -p system-genesis-block
configtxgen -profile TwoOrgsOrdererGenesis \
    -outputBlock ./system-genesis-block/genesis.block \
    -channelID system-channel
echo " Genesis block generated at system-genesis-block/genesis.block "

echo "===================================="
echo "Step 3: Generate Channel Artifacts"
echo "===================================="
mkdir -p channel-artifacts
configtxgen -profile TwoOrgsChannel \
    -outputCreateChannelTx ./channel-artifacts/channel.tx \
    -channelID $CHANNEL_NAME

configtxgen -profile TwoOrgsChannel \
    -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx \
    -channelID $CHANNEL_NAME \
    -asOrg Org1MSP
echo "✔️ Channel transaction and anchor peer update generated."


echo "Step 4: Launch Network (Docker)"

echo " Starting Fabric CA..."
docker-compose -f docker/docker-compose-ca.yaml up -d

echo " Starting Orderers and Peers..."
docker-compose -f docker/docker-compose-test-net.yaml up -d

echo " Waiting for containers to start..."
sleep 10


echo "Step 5: Create and Join Channel"

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH=$(pwd)/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

echo " Creating channel '$CHANNEL_NAME'..."
peer channel create \
    -o localhost:7050 \
    -c $CHANNEL_NAME \
    -f ./channel-artifacts/channel.tx \
    --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block

echo " Org1 peer joining channel..."
peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block


echo "Step 6: Update Anchor Peers"

peer channel update \
    -o localhost:7050 \
    -c $CHANNEL_NAME \
    -f ./channel-artifacts/Org1MSPanchors.tx

echo "Hyperledger Fabric federation network setup complete!"