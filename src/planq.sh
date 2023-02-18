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

# set variables
SOURCE=planq
BINARY=planqd 
CHAIN=planq_7070-2
FOLDER=.planqd
VERSION=v1.0.3
DENOM=aplanq
COSMOVISOR=cosmovisor
REPO=https://github.com/planq-network/planq
GENESIS=https://snap.nodexcapital.com/planq/genesis.json
ADDRBOOK=https://snap.nodexcapital.com/planq/addrbook.json
PORT=44


# export to bash profile
echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
# echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 2

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

	# update packages
	echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y

	# Installing dependencies
	echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
sudo apt install curl build-essential git wget jq make gcc tmux chrony lz4 -y

	# install go
	echo -e "\e[1m\e[32m3. Installing go... \e[0m" && sleep 1
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

	# download and build binaries
	echo -e "\e[1m\e[32m4. Downloading and building binaries... \e[0m" && sleep 1
cd $HOME
rm -rf $SOURCE
git clone $REPO
cd $SOURCE
git checkout $VERSION
make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

	# init chain & config app
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend file
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

	# export GOPATH
export PATH=$PATH:$(go env GOPATH)/bin

	# install & build cosmovisor
	echo -e "\e[1m\e[32m5. Install & build cosmovisor... \e[0m"
git clone https://github.com/cosmos/cosmos-sdk
cd cosmos-sdk
git checkout v0.46.7
make cosmovisor
cp cosmovisor/cosmovisor $GOPATH/bin/cosmovisor
cd $HOME

mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
mv $HOME/go/bin/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
rm -rf build
wget -O $HOME/$FOLDER/$COSMOVISOR/genesis/bin/$BINARY $REPO
chmod +x $HOME/$FOLDER/cosmovisor/genesis/bin/*
cp $GOPATH/bin/$BINARY ~/$FOLDER/$COSMOVISOR/genesis/bin

	# create app symlinks
ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/local/bin/$BINARY

	# Set seeds & persistent peers
	# seed and peers providing by: polkachu
	echo -e "\e[1m\e[32m6. Set seeds & persistent peers... \e[0m" && sleep 1
# sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/$FOLDER/config/config.toml
# external_address=$(wget -qO- eth0.me)
# sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/$FOLDER/config/config.toml
# # PEERS="8a19aa6e874ed5720aad2e7d02567ec932d92d22@141.94.248.63:26656,444b80ce750976df59b88ac2e08d720e1dbbf230@68.183.75.239:26666,20b4f9207cdc9d0310399f848f057621f7251846@222.106.187.13:40606,7ef67269c8ec37ff8a538a5ae83ca670fd2da686@137.184.192.123:26656,19afe579cc0a2b38ca87143f779f45e9a7f18a2f@18.134.191.148:26656,a23f002bda10cb90fa441a9f2435802b35164441@38.146.3.203:18256,bba6e85e3d1f1d9c127324e71a982ddd86af9a99@88.99.3.158:18256,966acc999443bae0857604a9fce426b5e09a7409@65.108.105.48:18256 ,177144bed1e280a6f2435d253441e3e4f1699c6d@65.109.85.226:8090,769ebaa9942375e70cebc21a75a2cfda41049d99@135.181.210.186:26656,8937bdacf1f0c8b2d1ffb4606554eaf08bd55df4@5.75.255.107:26656,99a0695a7358fa520e6fcd46f91492f7cf205d4d@34.175.159.249:26656,47401f4ac3f934afad079ddbe4733e66b58b67da@34.175.244.202:26656"
SEEDS=$(curl -sL https://raw.githubusercontent.com/planq-network/networks/main/mainnet/seeds.txt | awk '{print $1}' | paste -s -d, -)
# sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

	# Download genesis file & addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

	# Set custom ports, pruning & snapshots configuration
	echo -e "\e[1m\e[32m7. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml

	# Set config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$FOLDER/config/config.toml

	# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025$DENOM\"/" $HOME/$FOLDER/config/app.toml

	# Enable snapshots
	# Snapshot by NodeX 
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://snap.nodexcapital.com/planq/planq-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER


	# Create Service
	echo -e "\e[1m\e[32m8. Creating service files... \e[0m" && sleep 1
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


echo -e "\e[1m\e[35m================ KELAR CUY, JAN LUPA BUAT WALLET & REQ FAUCET ====================\e[0m"
echo ""
echo -e "\e[1m\e[36mTo check service status : systemctl status $BINARY\e[0m"
echo -e "\e[1m\e[33mTo check logs status : journalctl -fu dymd -o cat\e[0m"
echo -e "\e[1m\e[31mTo check Blocks status : $BINARY status 2>&1 | jq .SyncInfo\e[0m"
echo " "
sleep 2

