#!/bin/sh

echo "bootstrapping."

brew install bash
brew install nvim tmux cmake ag anaconda dotnet-sdk-preview swig htop python fzf fasd
pip install pynvim
pip3 install pynvim

# apt install -y llvm-6.0-doc llvm-6.0-examples llvm-6.0-tools llvm-6.0-runtime llvm-6.0 llvm-6.0-dev libclang-6.0-dev clang-6.0 clang-tools-6.0 clang-6.0-doc clang-6.0-examples
# apt install -y fasd

echo "Configuring user profile..."

git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
$HOME/.bash_it/install.sh --silent

cat >> $HOME/.bashrc <<EOF
# PATH=\$HOME/anaconda3/bin:\$PATH
alias vim=nvim
# alias ls='ls --color=auto -v -lh'
export THEME_SHOW_CLOCK_CHAR=false
EOF

# TODO do it in updated bash
# source $HOME/.bashrc; bash-it enable plugin powerline tmux less-pretty-cat fzf fasd; bash-it enable completion tmux ssh git pip


git clone https://github.com/v-yadli/vimrc $HOME/.config/nvim
nvim +PlugInstall +qall
cd $HOME/git/config 
git submodule init 
git submodule update --recursive
cd $HOME
ln -s $HOME/git/config/tmux/.tmux.conf ./
ln -s $HOME/git/config/tmux/.tmux ./
