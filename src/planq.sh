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
echo -e "Chain: \e[1m\e[32mplanq_7070-2\e[0m"
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
rm -rf planq/
git clone https://github.com/planq-network/planq.git
cd planq/
git fetch
git checkout v1.0.5
make build

	# install & build cosmovisor
	echo -e "\e[1m\e[32m5. Install & build cosmovisor... \e[0m"
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

mkdir -p $HOME/.planqd/cosmovisor/genesis/bin
mv build/planqd $HOME/.planqd/cosmovisor/genesis/bin/
rm -rf build


    # Create application symlinks
sudo ln -s $HOME/.planqd/cosmovisor/genesis $HOME/.planqd/cosmovisor/current
sudo ln -s $HOME/.planqd/cosmovisor/current/bin/planqd /usr/local/bin/planqd

    # Init config & chain
planqd config chain-id planq_7070-2
planqd config keyring-backend file
planqd config node tcp://localhost:${PORT}657
planqd init $NODENAME --chain-id planq_7070-2

	# Set seeds & persistent peers
	# seed and peers providing by: polkachu
	echo -e "\e[1m\e[32m6. Set seeds & persistent peers... \e[0m" && sleep 1
SEEDS=`curl -sL https://raw.githubusercontent.com/planq-network/networks/main/mainnet/seeds.txt | awk '{print $1}' | paste -s -d, -`
PEERS=`curl -sL https://raw.githubusercontent.com/planq-network/networks/main/mainnet/peers.txt | sort -R | head -n 10 | awk '{print $1}' | paste -s -d, -`
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.planqd/config/config.toml


    # Download genesis file & addrbook
wget -O ${HOME}/.planqd/config/addrbook.json https://raw.githubusercontent.com/planq-network/networks/main/mainnet/addrbook.json
wget -O ${HOME}/.planqd/config/genesis.json https://raw.githubusercontent.com/planq-network/networks/main/mainnet/genesis.json


	# Set custom ports, pruning & snapshots configuration
	echo -e "\e[1m\e[32m7. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.planqd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/.planqd/config/app.toml


# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.planqd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.planqd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.planqd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.planqd/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.planqd/config/config.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025aplanq\"/" $HOME/.planqd/config/app.toml


# Enable state sync
SNAP_RPC="https://planq-rpc.polkachu.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.planqd/config/config.toml

planqd tendermint unsafe-reset-all --home $HOME/.planqd --keep-addr-book

	# Create Service
	echo -e "\e[1m\e[32m8. Creating service files... \e[0m" && sleep 1
sudo tee /etc/systemd/system/planqd.service > /dev/null << EOF
[Unit]
Description=planqd node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.planqd"
Environment="DAEMON_NAME=planqd"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

# Start Service
sudo systemctl daemon-reload
sudo systemctl enable planqd
sudo systemctl start planqd

echo -e "\e[1m\e[35m================ Node Sucessfully Installed! ====================\e[0m"
echo ""
echo -e "\e[1m\e[36mTo check service status : systemctl status planqd\e[0m"
echo -e "\e[1m\e[33mTo check logs status : journalctl -fu planqd -o cat\e[0m"
echo -e "\e[1m\e[31mTo check Blocks status : planqd status 2>&1 | jq .SyncInfo\e[0m"
echo " "
sleep 2