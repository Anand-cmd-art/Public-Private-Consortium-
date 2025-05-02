#!/bin/bash
set -e

# 1️⃣ Make sure configtxgen can find configtx.yaml
export FABRIC_CFG_PATH="$(pwd)/configtx"
echo "FABRIC_CFG_PATH → $FABRIC_CFG_PATH"

# 2️⃣ Crypto generation
if [ ! -f "crypto-config/crypto-config.yaml" ]; then
  echo "ERROR: crypto-config/crypto-config.yaml not found"; exit 1
fi
cryptogen generate \
  --config=crypto-config/crypto-config.yaml \
  --output organizations
echo "✔ Crypto material in ./organizations/"

# 3️⃣ Genesis block (solo ordering)
mkdir -p system-genesis-block
configtxgen \
  -profile TwoOrgsOrdererGenesis \
  -outputBlock ./system-genesis-block/genesis.block \
  -channelID system-channel
echo "✔ Genesis block: system-genesis-block/genesis.block"

# 4️⃣ Channel artifacts for 'mychannel'
CHANNEL_NAME="mychannel"
mkdir -p channel-artifacts
configtxgen \
  -profile TwoOrgsChannel \
  -outputCreateChannelTx ./channel-artifacts/channel.tx \
  -channelID "$CHANNEL_NAME"
configtxgen \
  -profile TwoOrgsChannel \
  -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx \
  -channelID "$CHANNEL_NAME" \
  -asOrg Org1MSP
echo "✔ Channel tx & anchors in ./channel-artifacts/"

# 5️⃣ Start CAs, orderer & peers
docker-compose -f docker/docker-compose-ca.yaml up -d
docker-compose -f docker/docker-compose-test-net.yaml up -d

echo "Waiting for 10s for containers..."
sleep 10

# 6️⃣ Create & join the channel
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_MSPCONFIGPATH="$(pwd)/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
export CORE_PEER_ADDRESS=localhost:7051

peer channel create \
  -o localhost:7050 \
  -c "$CHANNEL_NAME" \
  -f ./channel-artifacts/channel.tx \
  --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block

peer channel join \
  -b ./channel-artifacts/${CHANNEL_NAME}.block

# 7️⃣ Update anchor peers
peer channel update \
  -o localhost:7050 \
  -c "$CHANNEL_NAME" \
  -f ./channel-artifacts/Org1MSPanchors.tx

echo "✅ Network setup complete!"
