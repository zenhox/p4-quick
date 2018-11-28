# p4-quick

## Introduction

A quick way to learn p4 language.

* The **env_up.sh** is a scirpt that help to set up p4 enviroment quickly. Please check your enviroment. This script has pass tests under my enviroment:
  * Ubuntu 16.04 desktop LTS.
  * Python 2.7.12
  * Please carefully read the **Before running the script**.
* If you are a mac or windows user, I recommand you to download the **P4-Suite2018.ova**, which is a vm image after the script:
  * [my ftp server] : ftp://118.25.136.129/hox/P4-Suite2018.ova
  * [cloud disk](https://share.weiyun.com/581m3WN)
  * username: myp4
  * password: myp4

## Before running the script

Please preinstall theses dependences:

```bash
sudo apt-get update

sudo apt-get install automake cmake libjudy-dev libpcap-dev libboost-dev libboost-test-dev libboost-program-options-dev libboost-system-dev libboost-filesystem-dev libboost-thread-dev libevent-dev libtool flex bison pkg-config g++ libssl-dev  -y

sudo apt-get install cmake g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev libboost-graph-dev llvm pkg-config python python-scapy python-ipaddr python-ply tcpdump curl  -y

sudo apt-get install libreadline6 libreadline6-dev  python-pip  -y 

## needed by tutorials
sudo pip install psutil  
sudo pip install crcmod
```

And then, **Note that:** my script recommand you to make a independent directory in home directory to hold p4 component:

```bash
mkdir ~/P4
cd ~/P4
echo "P4_HOME=$(pwd)" >> ~/.bashrc
source ~/.bashrc
```

After running these command lines, you will have an directory named **P4** in your home directory and a **$P4_HOME** envrioment variable in your current bash.

Now, download and copy the script to the **$P4_HOME**, and run it!

```bash
chmod +x env_up.sh
./env_up.sh
```

After the script down, Your enviroment has been set up with following directory tree:

```
P4
├── behavioral-model  ## BMv2 software switch
├── grpc              ## dependence of bmv2
├── mininet           ## mininet virtual network topology
├── p4c			      ## the p4 compiler
├── PI                ## P4 library
├── protobuf          ## dependence of PI and bmv2
└── tutorials         #### NOTE: this is tutorials directory and your workspace.
```

Now you can cd to tutorials and enjoy the exercises that P4 workgroup providing to you!



