# **EXORDE-LABS**
Incentivized Testnet

# Official Link
### [twitter](https://twitter.com/ExordeLabs)
### [discord](https://discord.gg/exordelabs)

# **1. Installasi**
 ## Menggunakan Docker
  
**Install Docker**
```
sudo apt update -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt install docker-ce
```

**Install Screen**
```
sudo apt install -y build-essential libssl-dev libffi-dev git curl screen
```

**Clone Repositori**
```
git clone https://github.com/exorde-labs/ExordeModuleCLI.git
```

**Build Docker**
```
cd ExordeModuleCLI
docker build -t exorde-cli . 
```

