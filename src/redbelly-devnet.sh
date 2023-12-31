#!/usr/bin/env bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

clear

# Displayed QB Logos
sleep 1 && curl -s https://raw.githubusercontent.com/DiscoverMyself/Exorde-Labs/resources/src/logo.sh | bash && sleep 1

# DNS & Port Configuration
echo 'Fully Qualified Domain Name - FQDN. (example => redbelly.qbnode.online / qbnode.online)'
read -r -p "Enter Your Domain Name (without https://) : " fqn
sleep 0.5
read -r -p "Enter Node ID - As Node Registration : " ID
sleep 0.5
read -r -p "Enter signing address for approval tx (Prefer Burner Wallet): " Signing
sleep 0.5
read -r -p "Enter Signing privatekey- Please Use fresh/burner new wallet: " Privkey
sleep 1
read -r -p "Enter RPC Port (Default: 8545) : " rpcport
sleep 0.5
read -r -p "Enter Websocket Port (Default: 8546) : " wsport
sleep 0.5

# Download Binaries, Genesis & Loader
git clone https://github.com/DiscoverMyself/rbn-files > /dev/null
mv $HOME/rbn-files/genesis.json $HOME/ > /dev/null
mv $HOME/rbn-files/rbbc $HOME/ > /dev/null
mv $HOME/rbn-files/spinner.sh $HOME/ > /dev/null
chmod +x spinner.sh > /dev/null
rm -rf rbn-files > /dev/null

# Update system and install build tools
sudo apt update > /dev/null
sudo apt install snapd > /dev/null
sudo snap install core > /dev/null
sudo snap refresh core > /dev/null
sudo apt install net-tools > /dev/null
sudo apt-get install -y cron curl unzip > /dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade > /dev/null
./spinner.sh "sleep 5" "..." "Update system and install build tools"

# Create Config File
tee /root/config.yaml  > /dev/null << EOF
ip: $fqn
id: $ID
genesisContracts:
  bootstrapContractsRegistryAddress: 0xDAFEA492D9c6733ae3d56b7Ed1ADB60692c98Bc5
consensusPort: 1888
grpcPort: 1111
privateKeyHex: $Privkey
poolConfig:
  initCap: 5
  maxCap: 30
  idleTimeout: 180
clientKeepAliveConfig:
  keepAliveTime: 1
  keepAliveTimeOut: 20
serverKeepAliveConfig:
  serverKeepAliveTime: 70
  serverKeepAliveTimeOut: 10
  minTime: 60
rpcPoolConfig:
  maxOpenCount: 1
  maxIdleCount: 1
  maxIdleTime: 30
EOF
./spinner.sh "sleep 3" "..." "Create Config File"

# Define Chain & Privkey for SSL
cpath="/etc/letsencrypt/live/"$fqn"/fullchain.pem" > /dev/null 
ppath="/etc/letsencrypt/live/"$fqn"/privkey.pem" > /dev/null 
sleep 1

# Create & Setup Observe Script for Config files

tee /root/observe.sh > /dev/null << EOF
#!/bin/sh
# filename: observe.sh
if [ ! -d rbn ]; then
  echo "rbn doesnt exist. Initialising redbelly"
  chmod +x genesis.json
  mkdir -p rbn
  mkdir -p consensus
  cp config.yaml ./consensus

  ./binaries/rbbc init --datadir=rbn --standalone
  rm -rf ./rbn/database/chaindata
  rm -rf ./rbn/database/nodes
  cp genesis.json ./rbn/genesis
else
  echo "rbn already exists. continuing with existing setup"
  cp config.yaml ./consensus
fi

rm -f log
./binaries/rbbc run --datadir=rbn --consensus.dir=consensus --tls --consensus.tls --tls.cert=$cpath --tls.key=$ppath --http --http.addr=0.0.0.0 --http.corsdomain=* --http.vhosts=* --http.port=$rpcport --http.api eth,net,web3,rbn --ws --ws.addr=0.0.0.0 --ws.port=$wsport --ws.origins="*" --ws.api eth,net,web3,rbn --threshold=200 --timeout=500 --logging.level info --mode production --consensus.type dbft --config.file config.yaml --bootstrap.tries=10 --bootstrap.wait=10 --recovery.tries=10 --recovery.wait=10
EOF

./spinner.sh "sleep 5" "..." "Create & Setup Observe Script for Config files"


# Create Main Script
tee /root/start-rbn.sh > /dev/null << EOF
#!/bin/sh
# filename: start-rbn.sh
mkdir -p binaries
mkdir -p consensus
chmod +x genesis.json
chmod +x config.yaml
chmod +x rbbc
cp rbbc binaries/rbbc
mkdir -p logs
nohup ./observe.sh > ./logs/rbbcLogs 2>&1 &
EOF

./spinner.sh "sleep 5" "..." "Create Main Script & Logs file"

chmod +x observe.sh > /dev/null
chmod +x start-rbn.sh > /dev/null

# Start The Node
./start-rbn.sh > /dev/null
./spinner.sh "sleep 10" "..." "Running the Node"

# Result
echo '=============================== ALL SET !!! ==============================='
echo -e "\e[1;32m Check your node status: \e[0m\e[1;36m${CYAN} pgrep rbbc ${NC}\e[0m"
echo -e "\e[1;32m Check your nodelogs  : \e[0m\e[1;36m${CYAN} cat ./logs/rbbcLogs ${NC}\e[0m"
echo '======================== THANK FOR YOUR SUPPORT ==========================='
echo -e '===============' "\e[0m\e[1;35m Join Our TG Channel: @HappyCuanAirdrop \e[0m" '=================='



