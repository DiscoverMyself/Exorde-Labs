#!/bin/bash
clear
echo ""
echo "Wait ..."
sleep 2
clear
       
echo -e "\e[1;35m
                                              .::::.                                                =++=   ...........     .+++:                           :+++.
   :=#%@@@%#+:                               =#@@@@@@@@#+.                                            @@@%  =@@@@@@@@@@@%+.  :@@@+                           +@@@-
 :%@@@@@@@@@@@-:##+.                       -@@@@#+==+#@@@@+                                           @@@#  =@@@%+++++#@@@%  :@@@+                           =@@@:
-@*-:.:-*@@@@@%.@@@@.                     -@@@%:      .#@@@+  *%%%    .%%%+    =#%@@@%#=.     -*%@@@%=@@@#  =@@@*     :@@@%  :@@@+    =#%@@@%*=      -+#%@@= +@@@:   *%%%-
#.        -%@@@:=@@@+                     %@@@-         @@@@. #@@@    .@@@*  :@@@@#*#@@@@-   #@@@%**%@@@@#  =@@@@%%%%%@@@*   :@@@+  -@@@@#*#@@@%:  :%@@@%##- +@@@: .#@@@-
.          -@@@#.@@@@           :         %@@@:         @@@@. #@@@    .@@@*  @@@%.   .%@@@. =@@@+    -@@@#  =@@@@%%%%%@@@#-  :@@@+ .@@@#    .%@@@  @@@%.     =@@@*+@@@@:
            %@@@.*@@@#.        ==         =@@@%.       *@@@*  #@@@    .@@@* .@@@#     *@@@: +@@@:    .@@@#  =@@@*      *@@@- :@@@+ :@@@+     *@@@..@@@#      =@@@@@%@@@@*
            =@@@#.@@@@@%+-..:=#%           =@@@@*-::-+%@@@*   =@@@*:.:#@@@-  #@@@*:.:*@@@@: .@@@%=:.-%@@@:  =@@@#-----=%@@@- :@@@+  #@@@+:.:*@@@*  +@@@*-::. =@@@:   =@@@*
             -*## #@@@@@@@@@@@*             .+%@@@@@@@@@*:     =%@@@@@@@%-    +@@@@@@%#@@@:  .*@@@@@@@@#:   =@@@@@@@@@@@@%=  :@@@+   =%@@@@@@@%=    -#@@@@@= +@@@:    @@@%
                   -*#%@@%%*=.                 .-%@@@=:          :-===-.        :===: .---      :-==-:.     .----------:.     ---.     .-===-.         .:--. .---     ---:
                                                 %@@@.
                                                 *###.
";



echo -e "\e[1;97m                                                                                     QBnode by: Aprame   \e[0m";
echo -e "\e[0m"


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
echo -e "Chain: \e[1m\e[32mgitopia\e[0m"
echo -e "Your Custom port: \e[1m\e[32m$PORT\e[0m"
echo '================================================='
sleep 2

	# Installing dependencies
	echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

	# install go
	echo -e "\e[1m\e[32m3. Installing go... \e[0m" && sleep 1
ver="1.20.1"
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
rm -rf gitopia
git clone https://github.com/gitopia/gitopia.git
cd gitopia
git checkout v2.0.0

make build
gitopiad version

	# install cosmovisor
	echo -e "\e[1m\e[32m5. Install & build cosmovisor... \e[0m"
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0


    # Build & Create application symlinks
mkdir -p $HOME/.gitopia/cosmovisor/genesis/bin
mv build/gitopiad $HOME/.gitopia/cosmovisor/genesis/bin/
rm -rf build

sudo ln -s $HOME/.gitopia/cosmovisor/genesis $HOME/.gitopia/cosmovisor/current
sudo ln -s $HOME/.gitopia/cosmovisor/current/bin/gitopiad /usr/local/bin/gitopiad


    # Init config & chain
gitopiad config chain-id gitopia
gitopiad config keyring-backend file
gitopiad config node tcp://localhost:${PORT}657
gitopiad init $NODENAME --chain-id gitopia

	# Set seeds & persistent peers
	# seed and peers providing by: polkachu
	echo -e "\e[1m\e[32m6. Set seeds & persistent peers... \e[0m" && sleep 1
SEEDS="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@seeds.polkachu.com:11356"
PEERS="7de2631f6bc7cc0caf30c3745d4795c1dbc91cf3@65.109.104.72:11356"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gitopia/config/config.toml

    # Download genesis file & addrbook
wget -O addrbook.json https://snapshots.polkachu.com/addrbook/gitopia/addrbook.json --inet4-only
mv addrbook.json ~/.gitopia/config

wget -O genesis.json https://snapshots.polkachu.com/genesis/gitopia/genesis.json --inet4-only
mv genesis.json ~/.gitopia/config


	# Set custom ports, pruning & snapshots configuration
	echo -e "\e[1m\e[32m7. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.gitopia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/.gitopia/config/app.toml


# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.gitopia/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.gitopia/config/config.toml

# Set minimum gas price
# sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0$DENOM\"/" $HOME/$FOLDER/config/app.toml

	# Create Service
	echo -e "\e[1m\e[32m8. Creating service files... \e[0m" && sleep 1
sudo tee /etc/systemd/system/gitopiad.service > /dev/null << EOF
[Unit]
Description=gitopiad node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.gitopia"
Environment="DAEMON_NAME=gitopia"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

# Enable service
sudo systemctl daemon-reload
sudo systemctl enable gitopiad

# Enable state sync
systemctl stop gitopiad
gitopiad tendermint unsafe-reset-all --home $HOME/.gitopia --keep-addr-book

SNAP_RPC="https://gitopia-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.gitopia/config/config.toml


# Start Service
sudo systemctl start gitopiad

echo -e "\e[1m\e[35m================ Node Sucessfully Installed! ====================\e[0m"
echo ""
echo -e "\e[1m\e[36mTo check service status : systemctl status gitopiad\e[0m"
echo -e "\e[1m\e[33mTo check logs status : journalctl -fu gitopiad -o cat\e[0m"
echo -e "\e[1m\e[31mTo check Blocks status : gitopiad status 2>&1 | jq .SyncInfo\e[0m"
echo " "
sleep 2
