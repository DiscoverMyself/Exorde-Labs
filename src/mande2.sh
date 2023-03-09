#!/bin/bash
echo ""
echo "Wait ..."
sleep 1
clear

# unset existing variables
unset SOURCE
unset BINARY
unset FOLDER
unset CHAIN
unset VERSION
unset DENOM
unset REPO
unset GENESIS
unset PORT
unset WALLET
unset NODENAME
cd; source .bashrc; cd -
clear

echo -e "\e[1;32m	                          											";
echo -e "\e[1;32m                                .------=======+.						";
echo -e "\e[1;32m                               :==+*****######%#:						";
echo -e "\e[1;32m                             .-====++++*#*###**#%:						";
echo -e "\e[1;32m                            .=======++++#######*#%-					";
echo -e "\e[1;32m                           :=========+++*#######*#%=					";
echo -e "\e[1;32m                         .-===========+*+*#########%=					";
echo -e "\e[1;32m                        -+++++++++++++::++**#######*%+					";
echo -e "\e[1;32m                       :=------------.  .+++**######*%*				";
echo -e "\e[1;32m                                         -*+++**#####*#*--				";
echo -e "\e[1;32m                                        .:=+**++**####*%#:				";
echo -e "\e[1;32m                   .-------:::::           .-=**+++**##=				";
echo -e "\e[1;32m                    -++++++++++=              .-+**+*+:				";
echo -e "\e[1;32m                   -+=======+==-                 :=+-					";
echo -e "\e[1;32m                 .=+++++++++===:                          .:+*.		";
echo -e "\e[1;32m                :++=++++++=====.                      .:=*###%#.		";
echo -e "\e[1;32m               -++=++++=======-                    .=++**###**#%:		";
echo -e "\e[1;32m             .=+++++========-=-                     =*++++*###*#%-		";
echo -e "\e[1;32m            -+=============: ..               .      -*++++***###%-	";
echo -e "\e[1;32m          .=+=============: .....          :-==:::::::=*++++++****%:	";
echo -e "\e[1;32m          .#####################%=      :-=++++++++++===+++++++++*=	";
echo -e "\e[1;32m           .*#*##################=   :-=+++==++==++======+++++++*=		";
echo -e "\e[1;32m            .*###################=  .=++==+++++++=========+++++*=		";
echo -e "\e[1;32m             .*****#########*****=    -++=++++=============+++*-		";
echo -e "\e[1;32m              .++++++*****++++++*-     .=+==================+*-		";
echo -e "\e[1;32m               .+****************=       -==----------------=-			";
echo -e "\e[1;32m                .:.::::::::::::::.        :=.							";
echo -e "\e[1;32m                                           .							";
echo -e "\e[1;32m	                          											";
echo -e "\e[1;35m                               R3 by: Aprame                      \e[0m";







# set new variables
# set variables
SOURCE=mande-chain
BINARY=mande-chaind
FOLDER=.mande-chain
CHAIN=mande-testnet-2
VERSION=v1.2.2
DENOM=mand
COSMOVISOR=cosmovisor
REPO=https://github.com/mande-labs/mande-chain.git
GENESIS=https://raw.githubusercontent.com/mande-labs/testnet-2/main/genesis.json
#ADDRBOOK=



echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# define user input as variable
read -p "Enter node name: " NODENAME
read -p "Enter your custom Port: " PORT

echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
echo 'export PORT='$PORT >> $HOME/.bash_profile
echo "export WALLET=wallet" >> $HOME/.bash_profile

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
	echo -e "\e[1m\e[32m3. Installing go... \e[0m" && sleep 1
ver="1.19.5"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version


	# download and build binaries
	echo -e "\e[1m\e[32m4. Downloading and building binaries... \e[0m" && sleep 1
cd $HOME
sudo rm -rf $SOURCE
git clone --branch $VERSION $REPO
cd $SOURCE
sudo curl https://get.ignite.com/cli! | bash
sudo ignite chain build --release -y
cd $HOME/mande-chain/release/
sudo tar -xvzf mande-chain_linux_amd64.tar.gz
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

	# install & build cosmovisor
	echo -e "\e[1m\e[32m5. Install & build cosmovisor... \e[0m"
sudo rm -rf /usr/bin/mande-chaind
sudo rm -rf /root/$FOLDER/cosmovisor/current/genesis
sudo mkdir -p $HOME/$FOLDER/cosmovisor/genesis/bin
sudo mv $BINARY $HOME/$FOLDER/cosmovisor/genesis/bin/
sudo rm $BINARY

    # Create application symlinks
sudo ln -s $HOME/$FOLDER/cosmovisor/genesis $HOME/$FOLDER/cosmovisor/current
sudo ln -s $HOME/$FOLDER/cosmovisor/current/bin/$BINARY /usr/bin/$BINARY

	# Init config & chain
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend file
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

	# Set seeds & persistent peers
	# seed and peers providing by: polkachu
	echo -e "\e[1m\e[32m6. Set seeds & persistent peers... \e[0m" && sleep 1
PEERS="dbd1f5b01f010b9e6ae6d9f293d2743b03482db5@34.171.132.212:26656,1d1da5742bdd281f0829124ec60033f374e9ddac@34.170.16.69:26656,aba89244024886c5cf724bf644cff3421367aedb@78.46.99.50:21656,aba89244024886c5cf724bf644cff3421367aedb@78.46.99.50:21656"
SEEDS=""
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

	# Download genesis file & addrbook
sudo curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
#sudo curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

	# Set custom ports, pruning & snapshots configuration
	echo -e "\e[1m\e[32m7. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
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

	# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/$FOLDER/config/config.toml

	# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025$DENOM\"/" $HOME/$FOLDER/config/app.toml

	# Enable statesync (by Apramnode)


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

	# Start Service
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl start $BINARY

echo -e "\e[1m\e[35m================ KELAR CUY, JAN LUPA CREATE/IMPORT WALLET ====================\e[0m"
echo ""
echo -e "To check service status : \e[1m\e[36msystemctl status $BINARY\e[0m"
echo -e "To check logs status : \e[1m\e[33mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "To check Blocks status : \e[1m\e[31mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo " "
sleep 2
