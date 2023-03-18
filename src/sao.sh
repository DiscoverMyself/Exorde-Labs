# by: Aprame
clear
echo ""
echo "Wait ..."
sleep 3
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

sleep 1




# Variable
SOURCE=sao-consensus
BINARY=saod
CHAIN=sao-testnet1
FOLDER=.sao
VERSION=v0.1.3
DENOM=sao
COSMOVISOR=cosmovisor
REPO=https://github.com/SaoNetwork/sao-consensus.git
GENESIS=https://raw.githubusercontent.com/sxlzptprjkt/resource/master/testnet/sao/genesis.json
ADDRBOOK=https://raw.githubusercontent.com/sxlzptprjkt/resource/master/testnet/sao/addrbook.json
PORT=20


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



# set var input
read -p "Enter your custom port: " PORT
read -p "Enter node name: " NODENAME
echo "export PORT=${PORT}" >> $HOME/.bash_profile
echo "export NODENAME=${NODENAME}" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$CHAIN\e[0m"
echo -e "Your Custom port: \e[1m\e[32m$PORT\e[0m"
echo '================================================='
sleep 2

    # Update
sudo apt update && sudo apt upgrade -y

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
git checkout $VERSION
make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0


	# install & build cosmovisor
	echo -e "\e[1m\e[32m4. Install & build cosmovisor... \e[0m"
mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
mv build/linux/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
rm -rf build

    # Create application symlinks
	echo -e "\e[1m\e[32m5. Create App symlinks... \e[0m"
ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/bin/$BINARY

    # Init gen
    echo -e "\e[1m\e[32m6. Init config & Chain... \e[0m"
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend test
$BINARY config node tcp://localhost:${PORT}57
$BINARY init $NODENAME --chain-id $CHAIN

    # Set peers and seeds
    echo -e "\e[1m\e[32m7. Set seeds & persistent peers... \e[0m" && sleep 1
PEERS="a5261e9fba12d7a59cd1d4515a449e705734c39b@peers-sao.sxlzptprjkt.xyz:27656"
SEEDS="e711b6631c3e5bb2f6c389cbc5d422912b05316b@seed.ppnv.space:41256"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

    # Download genesis and addrbook
    echo -e "\e[1m\e[32m8. Download genesis & addrbook... \e[0m" && sleep 1
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

    # Set custom ports
	echo -e "\e[1m\e[32m9. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml

    # Set app.tom configuration
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml

sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001$DENOM\"/" $HOME/$FOLDER/config/app.toml

    # Enable snapshots
    
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
systemctl daemon-reload
systemctl enable $BINARY
systemctl restart $BINARY

# state sync
sudo systemctl stop saod
cp $HOME/.sao/data/priv_validator_state.json $HOME/.sao/priv_validator_state.json.backup
saod tendermint unsafe-reset-all --home $HOME/.sao --keep-addr-book

SNAP_RPC="https://rpc-sao.sxlzptprjkt.xyz:443"
STATESYNC_PEERS="a5261e9fba12d7a59cd1d4515a449e705734c39b@peers-sao.sxlzptprjkt.xyz:27656"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.sao/config/config.toml
sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$STATESYNC_PEERS\"|" $HOME/.sao/config/config.toml

mv $HOME/.sao/priv_validator_state.json.backup $HOME/.sao/data/priv_validator_state.json
sudo systemctl start saod

echo -e "\e[1m\e[35m================ KELAR CUY, JAN LUPA BUAT WALLET & REQ FAUCET ====================\e[0m"
echo ""
echo -e "To check service status : \e[1m\e[36msystemctl status $BINARY\e[0m"
echo -e "To check logs status : \e[1m\e[33mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "To check Blocks status : \e[1m\e[31mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo " "
sleep 2

 journalctl -u saod -f --no-hostname -o cat
