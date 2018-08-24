#!/bin/sh

THIS_USER=`pstree -lu -s $$ | grep --max-count=1 -o '([^)]*)' | head -n 1 | sed 's/[()]//g'`

mkdir bootstrap && cd bootstrap

# install latest cmake

wget -q https://cmake.org/files/v3.12/cmake-3.12.0-Linux-x86_64.sh
sh cmake-3.12.0-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

# install anaconda

wget -q https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh
sudo -u $THIS_USER sh Anaconda3-5.2.0-Linux-x86_64.sh -b -f

# configure .NET installation

wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

apt install -y software-properties-common
apt install -y apt-transport-https

# configure various ppa

apt-add-repository -y ppa:neovim-ppa/unstable
add-apt-repository -y ppa:timsc/swig-3.0.12
add-apt-repository -y ppa:ubuntu-toolchain-r/test

# install packages

apt update
apt install -y dotnet-sdk-2.1
apt install -y build-essential g++ libssl-dev git htop silversearcher-ag swig3.0
apt install -y neovim
apt install -y unzip
apt install -y llvm-6.0-doc llvm-6.0-examples llvm-6.0-tools llvm-6.0-runtime llvm-6.0 llvm-6.0-dev libclang-6.0-dev clang-6.0 clang-tools-6.0 clang-6.0-doc clang-6.0-examples
apt install -y python-pip

cat >> $HOME/.bashrc <<EOF
PATH=\$HOME/anaconda3/bin:\$PATH
alias vim=nvim
EOF

pip2 install neovim
sudo -u $THIS_USER $HOME/anaconda3/bin/pip install neovim
sudo -u $THIS_USER mkdir -p $HOME/git && cd $HOME/git && git clone https://github.com/v-yadli/vimrc -b nvim $HOME/.config/nvim
sudo -u $THIS_USER source $HOME/.bashrc && nvim +PlugInstall +qall
cd $HOME/git/config 
sudo -u $THIS_USER && git submodule init && git submodule update --recursive
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux.conf ~/.tmux.conf
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux ~/.tmux
