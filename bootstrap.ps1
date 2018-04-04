. ./install_choco.ps1
. ./setup_ps.ps1
. ./setup_consolecolor.ps1
. ./setup_paths.ps1

# Development environment setup
refreshenv

pip install neovim jedi mistune psutil setproctitle
pip install python-language-server
# TODO hs env, lang server hie
# TODO ps1 env
# TODO cs env
#
