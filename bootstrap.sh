#!/bin/sh

THIS_USER=`pstree -lu -s $$ | grep --max-count=1 -o '([^)]*)' | head -n 1 | sed 's/[()]//g'`

mkdir $HOME/bootstrap && cd $HOME/bootstrap

echo "Install cmake..."

wget -q https://cmake.org/files/v3.12/cmake-3.12.0-Linux-x86_64.sh
sh cmake-3.12.0-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

echo "Install anaconda..."

wget -q https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
sudo -u $THIS_USER sh Anaconda3-5.2.0-Linux-x86_64.sh -b -f

echo "Configure .NET..."

wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

apt install -y software-properties-common
apt install -y apt-transport-https

echo "Configure various ppa..."

apt-add-repository -y ppa:neovim-ppa/unstable
add-apt-repository -y ppa:timsc/swig-3.0.12
add-apt-repository -y ppa:ubuntu-toolchain-r/test
add-apt-repository -y ppa:git-core/ppa

echo "Configure git-lfs..."

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

echo "Install apt packages..."

apt update
apt install -y dotnet-sdk-2.1
apt install -y build-essential g++ libssl-dev git htop silversearcher-ag swig3.0
apt install -y neovim
apt install -y unzip
apt install -y llvm-6.0-doc llvm-6.0-examples llvm-6.0-tools llvm-6.0-runtime llvm-6.0 llvm-6.0-dev libclang-6.0-dev clang-6.0 clang-tools-6.0 clang-6.0-doc clang-6.0-examples
apt install -y python-pip
apt install -y git-lfs
apt install -y default-jre

echo "Configuring user profile..."

cat >> $HOME/.bashrc <<EOF
PATH=\$HOME/anaconda3/bin:\$PATH
alias vim=nvim
EOF

pip2 install neovim
sudo -u $THIS_USER $HOME/anaconda3/bin/pip install neovim
sudo -u $THIS_USER git clone https://github.com/v-yadli/vimrc -b nvim $HOME/.config/nvim
sudo -u $THIS_USER nvim +PlugInstall +qall
cd $HOME/git/config 
sudo -u $THIS_USER git submodule init 
sudo -u $THIS_USER git submodule update --recursive
cd $HOME
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux.conf ./
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux ./
