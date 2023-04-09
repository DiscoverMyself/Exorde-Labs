# © 2023 by: Aprame
clear
echo ""
echo "Wait ..."
sleep 1
clear
       
echo -e "\e[35;1m                                                                   ";
echo -e "\e[35;1m                          ::::::.......:::....::.                   ";
echo -e "\e[35;1m                          :::::::::::::::::::::::                   ";
echo -e "\e[35;1m                       --:......:-:::::...::::..:--:                ";
echo -e "\e[35;1m                    ...:::-----=-:::::::::::::::::::...             ";
echo -e "\e[35;1m                   .--:..:++++++-.:::::::::..::::..:---             ";
echo -e "\e[35;1m                    ..:+=++++++++=+====...:::....:::===.            ";
echo -e "\e[35;1m                   .-:-+++++++++++++***=============***.            ";
echo -e "\e[35;1m                .:.-++++++++++++++++%%%%%%%%%%%%%%%%%%%:            ";
echo -e "\e[35;1m                ...-++++++++++++++=+%#%#############%#%:            ";
echo -e "\e[35;1m                .:.-+++++++++++++++*%#########%%%#####%:            ";
echo -e "\e[35;1m                .:.-+++======++=*%#%%%%%%%%%%%%%%%%%%%%:            ";
echo -e "\e[35;1m                .:.-+++******+++*%%*-=-----=-*%%*-=---=.            ";
echo -e "\e[35;1m                .:.-+=+%%%%%%+++*%%+         -%%+                   ";
echo -e "\e[35;1m                .:.-++*%#%%#%=-:+%%#*********#%%#*****#.            ";
echo -e "\e[35;1m                .:.-==+%##%#%=::+%#%%%%%%%%%%%%%%%%%%%%:            ";
echo -e "\e[35;1m                ...:::=%%%%%%=::+%%%%%%%%%%###%%%###%%%:            ";
echo -e "\e[35;1m             ...:::::::-:-###=::-=========#%%%%%%%%#===.            ";
echo -e "\e[35;1m             .:.::::...   +**-::::::::::::*#########:::             ";
echo -e "\e[35;1m             ...::::.:..:.   :::::::::::::----------::-             ";
echo -e "\e[35;1m             ...::::......   -==-::::::::::::::::::::::             ";
echo -e "\e[35;1m             ...::-.         +##=::::::::::::::::::::::             ";
echo -e "\e[35;1m             ....  :=====-   +#*=:::::::::::::::::::::-             ";
echo -e "\e[35;1m            ...   :*+***+   +##+---:::::::::::::::::::              ";
echo -e "\e[35;1m                   :*++*#*   *%%#*#+::::::::::--::::                ";
echo -e "\e[35;1m             :::---=++*##*-::-==+##*+++++++++-..:+==-::---.         ";
echo -e "\e[35;1m             +**###*++*#*****.  -%#%%%%%%%%%@=  .###***###-         ";
echo -e "\e[35;1m         .+==****++****++++++-::....         .::-*++***+++++*=      ";
echo -e "\e[35;1m         .*++*##*++*##*++++=+---.            .-:-+++****++**#+      ";
echo -e "\e[35;1m         .+++**#*++*##*+*+:::-==-::-===:::-==-::-===+++*##*++=      ";
echo -e "\e[35;1m         .+++**#*+++**+------------=###***###+------+++*##*+*=      ";
echo -e "\e[35;1m         .+++**#*+++++=:::===-::-==+@@@@@@@@@*==-:::+++*##*+*=      ";
echo -e "\e[35;1m                                                                    ";
echo -e "\e[35;1m                                                                    \e[0m";

sleep 1




# Variable
SOURCE=nibiru
BINARY=nibid
CHAIN=nibiru-itn-1
FOLDER=.nibid
VERSION=v0.19.2
DENOM=unibi
COSMOVISOR=cosmovisor
REPO=https://github.com/NibiruChain/nibiru.git
GENESIS=https://ss-t.nibiru.nodestake.top/genesis.json
ADDRBOOK=https://ss-t.nibiru.nodestake.top/addrbook.json
PORT=03


echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile


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
mv build/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
rm -rf build

    # Create application symlinks
	echo -e "\e[1m\e[32m5. Create App symlinks... \e[0m"
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/bin/$BINARY

    # Init gen
    echo -e "\e[1m\e[32m6. Init config & Chain... \e[0m"
$BINARY config chain-id $CHAIN
$BINARY config keyring-backend test
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

    # Set peers and seeds
    echo -e "\e[1m\e[32m7. Set seeds & persistent peers... \e[0m" && sleep 1
PEERS="8f4c4537a594095799b1885e60c2694e5d3d29f3@65.109.81.119:39656,436cb422506a1b3fc9c4e1e5920625e49babe161@185.219.142.214:26656,65a213efcad697afb5a1303c7fe5be4168d9520c@43.154.103.36:26656,a0ef091aed1da78640c84ea0ff81caaa55352bdc@43.159.194.246:26656,5ccedcf7f59e6e39b541779e2d3c73710db97c75@92.61.20.162:26656,b09b437584defd01ec3ab1595701ac1e71108c3c@91.196.164.128:26656,e665f29136f1f51baa4692975cf3bb5488381450@45.85.146.4:26656,b4d57d67d889678adfa5bc9e628f8b10c928839e@84.46.247.195:26656,2bfd18d860513e6f0f8c56d4d941b975bf825a50@173.249.7.203:36656,181e34e2d1c644400663644ca027c8ca65b30004@129.226.147.77:26657,f202744e2098cbf3c2fa512b1296463698787ba4@10.16.15.194:26656,637c4d2a687384db43a6859cf977f3c8006fdd2e@159.69.68.42:56656,c1365fac755ce06f15cecc2f0b7341a877c68067@78.47.10.170:26656,1876796c34e02c5f4efb08572bacae7612addf58@84.21.171.139:26656,bbc464aa22802b65367defd952f8fd13e5220b96@184.174.34.10:26656,06c707b1f8009502a805dfeb42d0c3806ed6a408@77.232.40.153:26656,1006710e216396697caf72a561498d1da1f563b4@81.0.218.86:26656,ecce9aad23cc1538c9cb2bfdbcb869b5c506d7d2@45.87.104.133:26656,4e6bfe976a1f43c2368a8ec59a8716138b46227d@43.155.106.215:26656,33f835723928978edb10f0df29aa3e2d6db1a11c@10.16.0.193:26656,6a9aa643613d9eb426abb8444db20f4d735e27ce@194.163.135.95:29656,2d674121d87cfd1e03654da8fda7ec9f21e46713@65.109.233.78:26656,e103e3c2286960faee1e5200e154757a87fa50f2@84.54.23.64:26656,7e69979ec2d46bce211f3e69017b2ff13e91e04f@49.12.217.230:26656,96affedb190616943366f5c64f78c44b214f565a@188.34.184.223:26656,9d4cf9e3188066fe24ad0794d34b2a77e570307e@23.88.70.106:26656,104a00413d0fc7ec208c810c50d49932da355bd5@129.226.159.141:26656,64fd92d5031e8f508ecf628426f855037a283734@157.230.27.97:26656,51af9ef1152aeef259359aac46ba0a4dc64b0167@65.109.229.77:26656,f43c2d42565b5109ed9951d7775c104ea2dcd58a@65.109.12.155:26656,c5af9535aaf811587769e90bce50cd70239f4efa@155.133.23.141:26656,9af233dad06aedef7ec5d97c4420560f3ea13d45@85.190.246.38:26656,9fa9473f19c6bda64ece54569f7334a59adb29e7@45.137.67.174:26656,a4e840c02ada08a4ee8a348dd6a069ac187c9eb4@10.16.0.56:26656,d2224271c70659665f7050ab63f365754ad60b14@84.46.247.246:26656,c9fa017c4e50ff843d3a216f96797c59b6e9735c@49.12.77.172:26656,8e14a9a21c206509e0d05a4360b4a0dc199efe3d@65.108.251.46:26656,d59f3743e2ea8d0b76cf1c9c70c4e3d5dd53e32f@77.120.115.137:39656,8279e11d79bb4d5ee3595893a546123423e48b6a@109.123.246.138:26656,12885f23b9f9b9aabe7b09828532ee041b9e0d46@212.23.221.221:26656,8f46b3f8d2e8b68c87fb6f1268d60dc47f258798@65.109.163.203:26656,6173aa0fb340ab41724d72339d164a86e7a6d0ac@185.229.119.95:26656,46a540d297aa7f93402a40d26c8b7f12d7198991@38.242.225.217:26656,ca6213c897bd8400d8d01b947a541db85ebb2d96@51.89.199.49:36656,cdb513db2227dac757c95b4a0c7784d2d753d29e@173.82.148.245:26656,b70ed6e681dbd23b071d07d6b6581f453f131e5d@65.21.154.41:26656,59851a542633185cf7244fa4901ac832c5f5bcd6@45.10.154.247:26656,d8ea1c268de97e1d66ec92abffacf9a690f2da6f@188.166.220.128:26656,2621076bd94906501513f3e602d05610dc4bbc07@43.154.84.192:26656,f093208f6cd6bea470cef7cc9dba1d4e12fd8284@38.242.153.85:26656,64fc94a56f69bae2ba8c23bfdf0f0c0ece535e68@184.174.34.119:26656,4f1c8f3de055988bf15f21b666369287fb5230de@31.220.73.148:26656,25e01aa86dae35ef0207991d1da02b7a9adf5e4a@38.242.219.103:26656,338890d004872f4be47ae804a38ec084b30f404d@77.220.215.39:26656,0fece210c0ca88a8c36abfd9ff6529564b6863f7@78.46.194.31:26656,86f0802858e59a4d56c7b73a206d9aa3edfc08f8@10.16.0.194:26656,932f77155b5a1989096451eee2b2eb4c1a4bc48a@194.163.191.69:26656,ce97214a4d272bb3677c4cbb39b1917d703c73c3@217.76.49.224:26656,75533faca91c0f8b249d268fa888f498feee0ba3@103.253.147.190:26656,aa882f345fd3febd66f0693d4525a537bdaa35ec@194.233.67.92:26656,a17948707e0301e4eb787b4fd2bdb37d72b0088a@10.16.0.17:26656,7510d7d796e7db59db2545c25a2b161b699d0817@109.123.246.120:26656,1dda615d0106f2ae7e246eff7a00a77a2e4ee809@5.9.63.211:26656,c45cde328f28c16b4da3e51c45a64c7ce0c45b1c@93.183.208.71:26656,bc5e4ef3ef9421754802a8833bc122a878f17d8e@91.149.187.22:26656,dadfc554e002c23241d3853b23e5301287d42621@43.159.195.32:26656,f98a8229e5dc6da6d5e49fd4e115472df3d1773c@95.9.36.100:26656,fefa7ae18436d8a0e39c56518d9d86464d1b601e@185.137.122.71:26656,6a822c4729b1ab9434a85489d2cd14556e416632@165.232.64.79:26656,385e57b19ab9d142b27bd0b4db3d8d84c83947e6@77.120.115.135:39656,1279e073e4e81a273f762822149c2c9321fb3812@10.16.0.43:26656,dbd69d21d37890b8a6154061522bd8b7dde2f549@109.123.251.235:26656,8234d259678864a204235bda9952c4183990ac4a@10.16.0.55:26656,d478d4a34de532833ec1c4df65f3b79f77265f17@10.16.15.196:26656,a3182e17fd73d5b02a14e011f0cb331278f9622e@10.16.0.15:26656,46c0cb4d56ebfd4c69911c59b3f17cb17bcc3ed7@64.226.94.147:26656,6903fcc270cb5189033124fece49ce4bb4745ba0@38.242.245.13:26656,775c740f19b3d02c08d8c1e3386ce20bf1c419ff@10.16.0.42:26656,47f57035e981957c0d8d87fdbab596834d10b951@130.185.119.230:29656,2b20d86dedeef2f2c14422804fe4f4db7bd2bf1f@154.53.55.128:29656,8c1e4bd5d50f33f2d4073318fb9cf8ebaac2ceb4@185.244.183.157:26656"
SEEDS="a431d3d1b451629a21799963d9eb10d83e261d2c@seed-1.itn-1.nibiru.fi:26656,6a78a2a5f19c93661a493ecbe69afc72b5c54117@seed-2.itn-1.nibiru.fi:26656"
# a431d3d1b451629a21799963d9eb10d83e261d2c@seed-1.itn-1.nibiru.fi:26656,6a78a2a5f19c93661a493ecbe69afc72b5c54117@seed-2.itn-1.nibiru.fi:26656
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
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/$FOLDER/config/app.toml
$BINARY tendermint unsafe-reset-all --home $HOME/$FOLDER --keep-addr-book
curl -L https://nibiru-t.service.indonode.net/nibiru-snapshot.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

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


# State Sync
sudo systemctl stop nibid
nibid tendermint unsafe-reset-all --home ~/.nibid/


SNAP_RPC="https://rpc-t.nibiru.nodestake.top:443"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" ~/.nibid/config/config.toml
more ~/.nibid/config/config.toml | grep 'rpc_servers'
more ~/.nibid/config/config.toml | grep 'trust_height'
more ~/.nibid/config/config.toml | grep 'trust_hash'


curl -L https://ss-t.nibiru.nodestake.top/wasm.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.nibid


    # Register And Start Service
systemctl daemon-reload
systemctl enable $BINARY
systemctl restart $BINARY


echo -e "\e[1m\e[35m================ KELAR CUY, JAN LUPA BUAT WALLET & REQ FAUCET ====================\e[0m"
echo ""
echo -e "To check service status : \e[1m\e[36msystemctl status $BINARY\e[0m"
echo -e "To check logs status : \e[1m\e[33mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "To check Blocks status : \e[1m\e[31mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo " "
sleep 2
