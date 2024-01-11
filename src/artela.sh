#!/usr/bin/env bash
exists()
{
  command -v "$1" > /dev/null 2>&1
}
if exists go; then
echo ''
else
ver="1.20.5" > /dev/null 2>&1
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" > /dev/null 2>&1
sudo rm -rf /usr/local/go > /dev/null 2>&1
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" > /dev/null 2>&1
rm "go$ver.linux-amd64.tar.gz" > /dev/null 2>&1
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile > /dev/null 2>&1
fi

clear

# Displayed QB Logos
sleep 1 && curl -s https://raw.githubusercontent.com/DiscoverMyself/Exorde-Labs/resources/src/logo.sh | bash && sleep 1

# Node & Port Configuration
read -r -p "Enter Your Node Name: " nodename
sleep 0.5
read -r -p "Enter your custom Port (Default: 26): " PORT
sleep 0.5

# Update system and install build tools
echo 'Installing prerequisites. take your coffee while waiting...'
sudo apt update > /dev/null 2>&1
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y > /dev/null 2>&1

# Download Binaries, and generate config file
cd $HOME > /dev/null 2>&1
git clone https://github.com/DiscoverMyself/sh-spinner > /dev/null 2>&1
mv $HOME/sh-spinner/spinner.sh $HOME/ > /dev/null 2>&1
chmod +x spinner.sh > /dev/null 2>&1
rm -rf sh-spinner > /dev/null 2>&1
rm -rf artela > /dev/null 2>&1
git clone https://github.com/artela-network/artela > /dev/null 2>&1
cd $HOME/artela && git checkout v0.4.7-rc4 && make install > /dev/null 2>&1
./spinner.sh "sleep 5" "..." "Download Binaries, Genesis & Addrbook"

#Initialize node
artelad config chain-id artela_11822-1 > /dev/null
artelad config keyring-backend test > /dev/null
artelad config node tcp://localhost:${PORT}657 > /dev/null
artelad init $nodename --chain-id artela_11822-1 > /dev/null
./spinner.sh "sleep 5" "..." "Initialize your node"

# Download Genesis & Addrbook file
curl -Ls https://ss-t.artela.nodestake.org/genesis.json > $HOME/.artelad/config/genesis.json > /dev/null
curl -Ls https://ss-t.artela.nodestake.org/addrbook.json > $HOME/.artelad/config/addrbook.json > /dev/null
./spinner.sh "sleep 3" "..." "Download Genesis & Addrbook file"

# Create Config File
sudo tee /etc/systemd/system/artelad.service > /dev/null
EOF
[Unit]
Description=artelad Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which artelad) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
./spinner.sh "sleep 3" "..." "Create Config File"

# State Sync
artelad tendermint unsafe-reset-all --home ~/.artelad/ --keep-addr-book > /dev/null 2>&1

SNAP_RPC="https://rpc-t.artela.nodestake.org:443" > /dev/null 2>&1
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \ > /dev/null 2>&1
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \ > /dev/null 2>&1
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) > /dev/null 2>&1
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH > /dev/null 2>&1
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \ > /dev/null 2>&1
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \ > /dev/null 2>&1
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \ > /dev/null 2>&1
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.artelad/config/config.toml > /dev/null 2>&1
more ~/.artelad/config/config.toml | grep 'rpc_servers' > /dev/null 2>&1
more ~/.artelad/config/config.toml | grep 'trust_height' > /dev/null 2>&1
more ~/.artelad/config/config.toml | grep 'trust_hash' > /dev/null 2>&1
./spinner.sh "sleep 7" "..." "Syncing your node to the latest block"

# Set Custom Port
FOLDER=.artelad > /dev/null 2>&1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml > /dev/null 2>&1
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml > /dev/null 2>&1



# Enable Systemctl for Artela services
sudo systemctl daemon-reload > /dev/null 2>&1
sudo systemctl enable artelad > /dev/null 2>&1
sudo systemctl restart artelad > /dev/null 2>&1
./spinner.sh "sleep 3" "..." "Enable Systemctl for Artela services"


# Start The Node
sudo systemctl restart artelad > /dev/null 2>&1
./spinner.sh "sleep 10" "..." "Running the Node"

# Result
echo '=============================== ALL SET !!! ==============================='
echo -e "\e[1;32m Check your node status: \e[0m\e[1;36m${CYAN} pgrep rbbc ${NC}\e[0m"
echo -e "\e[1;32m Check your nodelogs  : \e[0m\e[1;36m${CYAN} cat ./logs/rbbcLogs ${NC}\e[0m"
echo '======================== THANK FOR YOUR SUPPORT ==========================='
echo -e '===============' "\e[0m\e[1;35m Support Us! => contact@quadblock.net \e[0m" '=================='
