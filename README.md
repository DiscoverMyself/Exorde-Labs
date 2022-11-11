</p>

<p align="center">
  <img height="200" height="auto" src="https://user-images.githubusercontent.com/78480857/200719630-eee27a0c-2b29-42b8-a741-d852991e1e5e.jpg">
<p align="center">
  EXORDE LABS
</p>


# Official Link

### [WEB](https://exorde.network/)
### [TWITTER](https://twitter.com/ExordeLabs)
### [DISCORD](https://discord.gg/exordelabs)

# **1. Installation**
 ## Using Docker
  
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
wait 'till the output: ![exorde](https://user-images.githubusercontent.com/78480857/200719667-d1763911-fbbe-47ad-8cdf-99ccdf362311.png)

# **2. Start Node**

## Open Screen
```
screen -S exorde
```

## Start Docker
```
docker run -it exorde-cli -m [your_address] -l 2
```
*change: [your_address] with your metamask address (0x...)

the output should be: ![exorde2](https://user-images.githubusercontent.com/78480857/200719700-0239649f-f8f8-4b57-88a2-7f3516c15c56.png)

you can run it in the background (ctrl + A + D)

if you want to open again using 
```
screen -Rd exorde
```
**wait till validation success, and all file uploaded**
![exorde4](https://user-images.githubusercontent.com/78480857/200719727-3cb73159-cfa3-4fd6-9be8-eb9fe0fd3c3c.png)





# ! UPDATE !

## Quit Screen
```
screen -ls
screen -X -S [xxx.exorde] quit
```
([xxx.exorde] diisi sesuai output dari ```screen -ls``` tadi)


## Edit localConfig.json - last version 1.3.1 to 1.3.2
```
cd ExordeModuleCLI
nano localConfig.json
```

## Re-build Docker
```
docker build -t exorde-cli .
```
wait till build success

## Open Screen
```
screen -S exorde
```

## Start Docker
```
docker run -it exorde-cli -m [your_address] -l 2
```
*change: [your_address] with your metamask address (0x...)



all set!
