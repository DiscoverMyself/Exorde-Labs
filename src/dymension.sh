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
echo -e "Chain: \e[1m\e[32m35-C\e[0m"
echo -e "Your Custom port: \e[1m\e[32m$PORT\e[0m"
echo '================================================='
sleep 2

	# Installing dependencies
	echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

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
rm -rf dymension
git clone https://github.com/dymensionxyz/dymension.git
cd dymension
git checkout v0.2.0-beta
make build

	# install & build cosmovisor
	echo -e "\e[1m\e[32m5. Install & build cosmovisor... \e[0m"
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

mkdir -p $HOME/.dymension/cosmovisor/genesis/bin
mv bin/dymd $HOME/.dymension/cosmovisor/genesis/bin/
rm -rf build


    # Create application symlinks
sudo ln -s $HOME/.dymension/cosmovisor/genesis $HOME/.dymension/cosmovisor/current
sudo ln -s $HOME/.dymension/cosmovisor/current/bin/dymd /usr/local/bin/dymd

    # Init config & chain
dymd config chain-id 35-C
dymd config keyring-backend file
dymd config node tcp://localhost:${PORT}657
dymd init $NODENAME --chain-id 35-C

	# Set seeds & persistent peers
	# seed and peers providing by: polkachu
	echo -e "\e[1m\e[32m6. Set seeds & persistent peers... \e[0m" && sleep 1
# SEEDS=`curl -sL https://raw.githubusercontent.com/planq-network/networks/main/mainnet/seeds.txt | awk '{print $1}' | paste -s -d, -`
# PEERS=`curl -sL https://raw.githubusercontent.com/planq-network/networks/main/mainnet/peers.txt | sort -R | head -n 10 | awk '{print $1}' | paste -s -d, -`
# sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.dymension/config/config.toml


    # Download genesis file & addrbook
wget -O ${HOME}/.dymension/config/addrbook.json https://ss-t.dymension.nodestake.top/addrbook.json
wget -O ${HOME}/.dymension/config/genesis.json https://ss-t.dymension.nodestake.top/genesis.json


	# Set custom ports, pruning & snapshots configuration
	echo -e "\e[1m\e[32m7. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.dymension/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/.dymension/config/app.toml


# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.dymension/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.dymension/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.dymension/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.dymension/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.dymension/config/config.toml

# Set minimum gas price
# sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025aplanq\"/" $HOME/.dymension/config/app.toml

	# Create Service
	echo -e "\e[1m\e[32m8. Creating service files... \e[0m" && sleep 1
sudo tee /etc/systemd/system/dymd.service > /dev/null << EOF
[Unit]
Description=dymd node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.dymension"
Environment="DAEMON_NAME=dymd"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

# Enable Service
sudo systemctl daemon-reload
sudo systemctl enable dymd

# Enable state sync
sudo systemctl stop dymd

cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
dymd tendermint unsafe-reset-all --home $HOME/.dymension --keep-addr-book

SNAP_RPC="https://dymension-testnet.nodejumper.io:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height)
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000))
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

PEERS="76fb074cb54791afa399979ca863da211404bad6@dymension-testnet.nodejumper.io:27656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.dymension/config/config.toml
sed -i 's|^enable *=.*|enable = true|' $HOME/.dymension/config/config.toml
sed -i 's|^rpc_servers *=.*|rpc_servers = "'$SNAP_RPC,$SNAP_RPC'"|' $HOME/.dymension/config/config.toml
sed -i 's|^trust_height *=.*|trust_height = '$BLOCK_HEIGHT'|' $HOME/.dymension/config/config.toml
sed -i 's|^trust_hash *=.*|trust_hash = "'$TRUST_HASH'"|' $HOME/.dymension/config/config.toml

mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json


# Start Service
sudo systemctl start dymd

echo -e "\e[1m\e[35m================ Node Sucessfully Installed! ====================\e[0m"
echo ""
echo -e "\e[1m\e[36mTo check service status : systemctl status dymd\e[0m"
echo -e "\e[1m\e[33mTo check logs status : journalctl -fu dymd -o cat\e[0m"
echo -e "\e[1m\e[31mTo check Blocks status : dymd status 2>&1 | jq .SyncInfo\e[0m"
echo " "
sleep 2