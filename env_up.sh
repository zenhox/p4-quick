#!/bin/bash
##############################################################
# origin author : P4 Lang
# modified by: MMH
# function: Set up p4 enviroment quickly
##############################################################

# print commands
set -x
# stop on error
set -e

# set some path and variable
P4_HOME=$HOME/P4
BMV2_COMMIT="27c235944492ef55ba061fcf658b4d8102d53bd8"  # Apr 23, 2021
PI_COMMIT="0687ef29b48d88c64dab294e09c85c8894e41be6"    # Apr 23, 2021
P4C_COMMIT="32b157cf164148e8bbbd1f5378b8dd768888e76f"   # Apr 23, 2021
PROTOBUF_COMMIT="v3.6.1"
GRPC_COMMIT="v1.17.2" 
NUM_CORES=`grep -c ^processor /proc/cpuinfo`

cd $P4_HOME
# install mininet
git clone git://github.com/mininet/mininet mininet
cd mininet
sudo ./util/install.sh -nwv
cd ..

# install protocol
git clone https://github.com/google/protobuf.git
cd protobuf
git checkout ${PROTOBUF_COMMIT}
export CFLAGS="-Os"
export CXXFLAGS="-Os"
export LDFLAGS="-Wl,-s"
./autogen.sh
./configure --prefix=/usr
make -j${NUM_CORES}
sudo make install
sudo ldconfig
unset CFLAGS CXXFLAGS LDFLAGS
# force install python module
cd python
sudo python setup.py install
cd ../..

# install grpc
git clone https://github.com/grpc/grpc.git
cd grpc
git checkout ${GRPC_COMMIT}
git submodule update --init --recursive
export LDFLAGS="-Wl,-s"
make -j${NUM_CORES}
sudo make install
sudo ldconfig
unset LDFLAGS
cd ..
# Install gRPC Python Package
sudo pip install grpcio

# install dependences of bmv2, which is needed by PI
git clone https://github.com/p4lang/behavioral-model.git
cd behavioral-model
git checkout ${BMV2_COMMIT}
# From bmv2's install_deps.sh, we can skip apt-get install.
# Nanomsg is required by p4runtime, p4runtime is needed by BMv2...
tmpdir=`mktemp -d -p .`
cd ${tmpdir}
bash ../travis/install-thrift.sh
bash ../travis/install-nanomsg.sh
sudo ldconfig
bash ../travis/install-nnpy.sh
cd ..
sudo rm -rf $tmpdir
cd ..

# PI/P4Runtime
git clone https://github.com/p4lang/PI.git
cd PI
git checkout ${PI_COMMIT}
git submodule update --init --recursive
./autogen.sh
./configure --with-proto
make -j${NUM_CORES}
sudo make install
sudo ldconfig
cd ..

# install bmv2
cd behavioral-model
./autogen.sh
./configure --enable-debugger --with-pi
make -j${NUM_CORES}
sudo make install
sudo ldconfig
# Simple_switch_grpc target
cd targets/simple_switch_grpc
./autogen.sh
./configure --with-thrift
make -j${NUM_CORES}
sudo make install
sudo ldconfig
cd ..
cd ..
cd ..

# install p4c without check
git clone https://github.com/p4lang/p4c
cd p4c
git checkout ${P4C_COMMIT}
git submodule update --init --recursive
mkdir -p build
cd build
cmake ..
make -j${NUM_CORES}
# make -j${NUM_CORES} check <- skip tests as p4c tests are failing currently
sudo make install
sudo ldconfig
cd ..
cd ..

# get p4 tutorials 
sudo pip install crcmod
git clone https://github.com/p4lang/tutorials
sudo mv tutorials /home/p4
sudo chown -R p4:p4 /home/p4/tutorials

# Vim
cd /home/p4
mkdir .vim
cd .vim
mkdir ftdetect
mkdir syntax
echo "au BufRead,BufNewFile *.p4      set filetype=p4" >> ftdetect/p4.vim
echo "set bg=dark" >> /home/p4/.vimrc
sudo mv /home/p4/.vimrc /home/p4/.vimrc
cp /home/p4/p4.vim syntax/p4.vim
cd /home/p4
sudo mv .vim /home/p4/.vim
