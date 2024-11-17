
bash
#!/bin/bash

curl -s (link unavailable) | bash
sleep 3

show() {
  echo
  echo -e "\e[1;34m$1\e[0m"
  echo
}

if ! [ -x "$(command -v git)" ]; then
  show "Git is not installed. Installing git..."
  sudo apt-get update && sudo apt-get install git -y
else
  show "Git is already installed."
fi

show "Installing npm..."
source <(wget -O - https://raw.githubusercontent.com/zunxbt/installation/main/node.sh)

if [ -d "Story-Protocol" ]; then
  show "Removing existing Story directory..."
  rm -rf Story-Protocol
fi

show "Cloning Story repository..."
git clone https://github.com/zunxbt/Story-Protocol.git && cd Story-Protocol

show "Installing npm dependencies..."
npm install

# Hardcoded private key and JWT token
WALLET="08dd9462d41644896e84392092ba07b0ff02a3b64493bf1616c7923d11faa7c8"
JWT="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiJmYzFmYzg4Yi0xMDdhLTQwYmItOTU1Yi01M2NiYjViZWVjZGIiLCJlbWFpbCI6Imdvb2RsdWNrZGFuaWVsNDMyQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwaW5fcG9saWN5Ijp7InJlZ2lvbnMiOlt7ImRlc2lyZWRSZXBsaWNhdGlvbkNvdW50IjoxLCJpZCI6IkZSQTEifSx7ImRlc2lyZWRSZXBsaWNhdGlvbkNvdW50IjoxLCJpZCI6Ik5ZQzEifV0sInZlcnNpb24iOjF9LCJtZmFfZW5hYmxlZCI6ZmFsc2UsInN0YXR1cyI6IkFDVElWRSJ9LCJhdXRoZW50aWNhdGlvblR5cGUiOiJzY29wZWRLZXkiLCJzY29wZWRLZXlLZXkiOiJlYWU0MjhjZGIwZDEzNzUwMDA1MSIsInNjb3BlZEtleVNlY3JldCI6ImNiZTIzNDMzZTYzY2Y1ZWM3YjE2NzIwMDRhNjlhZTk3Y2IzMTEwOWEyYmExZjI5ODc5MjgyOWNhNmZhZDE4MWQiLCJleHAiOjE3NjMzMTM2MzZ9.B-1Ghn0hoCcKvSg0I2Ie-Tu2gMA6Gff2Z5cGTFsf4uk"

cat <<EOF > .env
WALLET_PRIVATE_KEY=$WALLET
PINATA_JWT=$JWT
EOF

show "Running npm script to create SPG collection..."
npm run create-spg-collection

read -p "Enter NFT contract address: " CONTRACT
echo
echo "NFT_CONTRACT_ADDRESS=$CONTRACT" >> .env

show "Running npm script for metadata..."
npm run metadata
echo
