#!/bin/sh

THIS_USER=`pstree -lu -s $$ | grep --max-count=1 -o '([^)]*)' | head -n 1 | sed 's/[()]//g'`

mkdir $HOME/bootstrap && cd $HOME/bootstrap

echo "Install cmake..."

wget -q https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0-Linux-x86_64.sh 
sh cmake-3.18.0-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

echo "Install anaconda..."

wget -q https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
sudo -u $THIS_USER sh Anaconda3-2020.02-Linux-x86_64.sh -b -f

echo "Configure various ppa..."

apt-add-repository -y ppa:neovim-ppa/unstable

apt update
apt install -y build-essential g++ git htop atop iotop iftop silversearcher-ag neovim unzip

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

sudo -u $THIS_USER $HOME/anaconda3/bin/pip install pynvim
sudo -u $THIS_USER $HOME/anaconda3/bin/pip install python-language-server
sudo -u $THIS_USER $HOME/anaconda3/bin/pip install argcomplete
sudo -u $THIS_USER git clone https://github.com/v-yadli/vimrc -b nvim $HOME/.config/nvim
sudo -u $THIS_USER nvim +PlugInstall +qall
if [ ! -d $HOME/git/config ]
then
  sudo -u $THIS_USER mkdir -p $HOME/git
  sudo -u $THIS_USER git clone https://github.com/v-yadli/config $HOME/git/config
fi
cd $HOME/git/config 
sudo -u $THIS_USER git submodule init 
sudo -u $THIS_USER git submodule update --recursive
cd $HOME
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux.conf ./
sudo -u $THIS_USER ln -s $HOME/git/config/tmux/.tmux ./

curl -s https://install-node.now.sh | bash -s -- -y
rm ~/.wget-hst
