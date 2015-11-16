#!/usr/bin/env zsh
# vim: set noexpandtab tabstop=4 shiftwidth=0:

set -x -e
export DOTFILES_PATH="$PWD"
export HOME="$(mktemp -d)"

_DOTFILES_CLOBBER=true $DOTFILES_PATH/install.sh

cd $HOME
set +x
echo '++ Starting ZSH in new environment. Message will print when that shell exits'
zsh -i -l
echo "++ END OF $@ ++"
