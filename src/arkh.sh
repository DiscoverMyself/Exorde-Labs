#!/bin/bash
clear
echo ""
echo "Wait ..."
sleep 3
clear
       
echo -e "\e[1;32m	                          ";
echo -e "\e[1;32m	    _____\    _______     ";
echo -e "\e[1;32m	   /      \  |      /\    ";
echo -e "\e[1;32m	  /_______/  |_____/  \   ";
echo -e "\e[1;32m	 |   \   /        /   /   ";
echo -e "\e[1;32m	  \   \         \/   /    ";
echo -e "\e[1;32m	   \  /    R3    \__/_    ";
echo -e "\e[1;32m	    \/ ____    /\         ";
echo -e "\e[1;32m	      /  \    /  \        ";
echo -e "\e[1;32m	     /\   \  /   /        ";
echo -e "\e[1;32m	       \   \/   /         ";
echo -e "\e[1;32m	        \___\__/          ";
echo -e "\e[1;32m	                          ";
echo -e "\e[1;35m	     R3 by: Aprame   \e[0m";
echo -e "\e[0m"

sleep 1

# set variables
SOURCE=arkh-blockchain
WALLET=wallet
BINARY=arkhd
FOLDER=.arkh
CHAIN="arkh"
#VERSION=v1.0.0
DENOM=arkh
COSMOVISOR=cosmovisor
REPO=https://github.com/vincadian/arkh-blockchain
GENESIS=https://github.com/vincadian/arkh-blockchain/genesis/genesis.json
#ADDRBOOK=https://snap.nodexcapital.com/planq/addrbook.json
PORT=18

echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# set vars input
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi

echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$CHAIN\e[0m"
echo -e "Your Custom port: \e[1m\e[32m$PORT\e[0m"
echo '================================================='
sleep 2

    # Installing dependencies
	echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

    # install go
	echo -e "\e[1m\e[32m2. Installing go... \e[0m" && sleep 1
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

    # download and build binaries
	echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
cd $HOME
rm -rf $SOURCE
git clone $REPO
cd $SOURCE
git checkout #$VERSION
make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

	# install & build cosmovisor
	echo -e "\e[1m\e[32m4. Install & build cosmovisor... \e[0m"
mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
mv target/release/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
rm -rf build

    # Create application symlinks
	echo -e "\e[1m\e[32m5. Create App symlinks... \e[0m"
ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/local/bin/$BINARY

    # Init generation
    echo -e "\e[1m\e[32m6. Init config & Chain... \e[0m"
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend test
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

    # Set peers and seeds
    echo -e "\e[1m\e[32m7. Set seeds & persistent peers... \e[0m" && sleep 1
PEERS="808f01d4a7507bf7478027a08d95c575e1b5fa3c@asc-dataseed.arkhadian.com:26656"
SEEDS="808f01d4a7507bf7478027a08d95c575e1b5fa3c@asc-dataseed.arkhadian.com:26656"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

    # Download genesis and addrbook
    echo -e "\e[1m\e[32m8. Download genesis & addrbook... \e[0m" && sleep 1
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
#curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json


	echo -e "\e[1m\e[32m7. Set custom ports, pruning & snapshots configuration ...\e[0m" && sleep 1
    # Set custom ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml

    # Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml

    # Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025$DENOM\"/" $HOME/$FOLDER/config/app.toml

    # Create Service
    echo -e "\e[1m\e[32m8. Creating service file...\e[0m" && sleep 1
sudo tee /etc/systemd/system/$BINARY.service > /dev/null << EOF
[Unit]
Description=$BINARY
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/$FOLDER"
Environment="DAEMON_NAME=$BINARY"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

    # Register And Start Service
sudo systemctl start $BINARY
sudo systemctl daemon-reload
sudo systemctl enable $BINARY

    # Enable snapshots
SNAP_RPC="https://asc-dataseed.arkhadian.com:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sudo systemctl stop $BINARY
$BINARY unsafe-reset-all --home ~/.arkh/

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" ~/.arkh/config/config.toml
more ~/.arkh/config/config.toml | grep 'rpc_servers'
more ~/.arkh/config/config.toml | grep 'trust_height'
more ~/.arkh/config/config.toml | grep 'trust_hash'

sudo systemctl restart $BINARY

echo -e "\e[1m\e[35m================ KELAR CUY, JAN LUPA BUAT WALLET & REQ FAUCET ====================\e[0m"
echo ""
echo -e "\e[1m\e[36mTo check service status : systemctl status $BINARY\e[0m"
echo -e "\e[1m\e[33mTo check logs status : journalctl -fu $BINARY -o cat\e[0m"
echo -e "\e[1m\e[31mTo check Blocks status : curl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo " "
sleep 2