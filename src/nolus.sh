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
echo -e "Chain: \e[1m\e[32mpirin-1\e[0m"
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
rm -rf nolus-core
git clone https://github.com/nolus-protocol/nolus-core
cd nolus-core
git checkout v0.3.0
make build

	# install & build cosmovisor
	echo -e "\e[1m\e[32m5. Install & build cosmovisor... \e[0m"
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

mkdir -p $HOME/.nolus/cosmovisor/genesis/bin
mv target/release/nolusd $HOME/.nolus/cosmovisor/genesis/bin/
rm -rf build


    # Create application symlinks
sudo ln -s $HOME/.nolus/cosmovisor/genesis $HOME/.nolus/cosmovisor/current
sudo ln -s $HOME/.nolus/cosmovisor/current/bin/nolusd /usr/local/bin/nolusd

    # Init config & chain
nolusd config chain-id pirin-1
nolusd config keyring-backend file
nolusd config node tcp://localhost:${PORT}657
nolusd init $NODENAME --chain-id pirin-1

	# Set seeds & persistent peers
	# seed and peers providing by: polkachu
	echo -e "\e[1m\e[32m6. Set seeds & persistent peers... \e[0m" && sleep 1
PEERS=39fa78be2d32bde352c7252c219f75ad81aaf14a@144.76.40.53:19756,18845b356886a99ee704f7a06de79fc8208b47d1@57.128.96.155:19756,e5e2b4ae69c1115f126abcd5aa449842e29832b0@51.255.66.46:2110,13f2ff36f5caeec4bca6705aebc0ce5fb65aefb3@168.119.89.8:27656,6cceba286b498d4a1931f85e35ea0fa433373057@169.155.170.20:26656,7740f125a480d1329fa1015e7ea97f09ee4eded7@107.135.15.66:26746,488c9ee36fc5ee54e662895dfed5e5df9a5ff2d5@136.243.39.118:26656,aeb6c84798c3528b20ee02985208eb72ed794742@185.246.87.116:26666,cbbb839a7fee054f7e272688787200b2b847bbf0@103.180.28.91:26656,67d569007da736396d7b636224b97349adcde12f@51.89.98.102:55666,e16568ad949050e0a817bddaf651a8cce04b0e7a@176.9.70.180:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nolus/config/config.toml

    # Download genesis file & addrbook
wget -O genesis.json https://ss.nodeist.net/nolus/genesis.json --inet4-only
mv genesis.json ~/.nolus/config


	# Set custom ports, pruning & snapshots configuration
	echo -e "\e[1m\e[32m7. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/.nolus/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/.nolus/config/app.toml


# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nolus/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nolus/config/app.toml

# Set Config prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.nolus/config/config.toml

# Set minimum gas price

	# Create Service
	echo -e "\e[1m\e[32m8. Creating service files... \e[0m" && sleep 1
sudo tee /etc/systemd/system/nolusd.service > /dev/null << EOF
[Unit]
Description=nolusd node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.nolus"
Environment="DAEMON_NAME=nolusd"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

# Enable Service
sudo systemctl daemon-reload
sudo systemctl enable nolusd

# Enable snapshot
sudo systemctl stop nolusd
cp $HOME/.nolus/data/priv_validator_state.json $HOME/.nolus/priv_validator_state.json.backup
rm -rf $HOME/.nolus/data

curl -L https://ss.nodeist.net/nolus/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nolus --strip-components 2
mv $HOME/.nolus/priv_validator_state.json.backup $HOME/.nolus/data/priv_validator_state.json


# Start Service
sudo systemctl start nolusd && sudo journalctl -u nolusd -f --no-hostname -o cat

echo -e "\e[1m\e[35m================ Node Sucessfully Installed! ====================\e[0m"
echo ""
echo -e "\e[1m\e[36mTo check service status : systemctl status nolusd\e[0m"
echo -e "\e[1m\e[33mTo check logs status : journalctl -fu nolusd -o cat\e[0m"
echo -e "\e[1m\e[31mTo check Blocks status : nolusd status 2>&1 | jq .SyncInfo\e[0m"
echo " "
sleep 2