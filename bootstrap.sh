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
add-apt-repository -y ppa:aacebedo/fasd


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
apt install -y fasd

echo "Configuring user profile..."

sudo -u $THIS_USER git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
sudo -u $THIS_USER $HOME/.bash_it/install.sh --silent

cat >> $HOME/.bashrc <<EOF
PATH=\$HOME/anaconda3/bin:\$PATH
alias vim=nvim
alias ls='ls --color=auto -v -lh'
export THEME_SHOW_CLOCK_CHAR=false
EOF

sudo -u $THIS_USER "source $HOME/.bashrc; bash-it enable plugin powerline tmux less-pretty-cat fzf fasd; bash-it enable completion tmux ssh git pip conda
"

pip2 install neovim
sudo -u $THIS_USER $HOME/anaconda3/bin/pip install neovim neovim-remote
sudo -u $THIS_USER $HOME/anaconda3/bin/pip install python-language-server
sudo -u $THIS_USER $HOME/anaconda3/bin/pip install argcomplete
sudo -u $THIS_USER git clone https://github.com/v-yadli/vimrc -b nvim $HOME/.config/nvim
sudo -u $THIS_USER nvim +PlugInstall +qall
cd $HOME/git/config 
sudo -u $THIS_USER git submodule init 
sudo -u $THIS_USER git submodule update --recursive
cd $HOME
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux.conf ./
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux ./
