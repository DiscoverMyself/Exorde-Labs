</p>

<p align="center">
  <img height="200" height="auto" src="https://user-images.githubusercontent.com/78480857/200719630-eee27a0c-2b29-42b8-a741-d852991e1e5e.jpg">
<p align="center">
  EXORDE LABS
</p>



## Persyaratan Hardware

- Memory  : 4 GB RAM
- CPU     : 2 or more physical CPU cores
- Disk    : -+ 40 GB SSD Storage
- OS      : Ubuntu 18.04 LTS

## Set Vars

```bash
  WALLET_ADDRESS=<METAMASK WALLET ADDRESS>
```
Change <METAMASK WALLET ADDRESS> To your Metamask Wallet Address

```bash
echo export WALLET_ADDRESS=${WALLET_ADDRESS} >> $HOME/.bash_profile
source ~/.bash_profile
```

## Update Packages and Dependencies
```bash
cd $HOME
sudo apt update && sudo apt upgrade -y
sudo apt install curl build-essential git wget npm jq make gcc tmux -y && apt purge docker docker-engine docker.io containerd docker-compose -y
```

## Intsall Docker
```bash
rm /usr/bin/docker-compose /usr/local/bin/docker-compose
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
systemctl restart docker
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker --version
```
## Clone Repository
```bash
git clone https://github.com/exorde-labs/ExordeModuleCLI.git
cd ExordeModuleCLI
```

```bash
docker build -t exorde-cli .
```

## Run Exorder CLI through Docker
### This runs in the background

```bash
docker run -d -it --name Exorde exorde-cli -m $WALLET_ADDRESS -l 4
```

You can change the logs by changing ``4`` :

0 = no logs
  
1 = general logs
  
2 = validation logs
  
3 = validation + scraping logs

4 = detailed validation + scraping logs (e.g. for troubleshooting)

## Useful commands
 

Check logs

```bash
docker logs Exorde
```
Check logs constantly

```bash
docker logs --follow Exorde

```
Check Explore

```bash
https://explorer.exorde.network/
```

Restart 
  
(untuk pertama kali restart)
```
DOCKER_ID=$(docker ps -aqf "name=Exorde")
echo 'export DOCKER_ID='${DOCKER_ID} >> $HOME/.bash_profile
source $HOME/.bash_profile
docker restart $DOCKER_ID
```
jika sudah pernah memasukkan command diatas, selanjutnya jika restart lagi cukup dengan command
```
docker restart $DOCKER_ID
```

To delete node

```bash
sudo  docker stop Exorde &&  sudo  docker  rm Exorde
sudo  rm -rf ExordeModuleCLI
 ```
