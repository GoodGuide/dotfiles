#!/bin/bash
# vim: set noexpandtab tabstop=4 shiftwidth=0:
set -e -u

if [[ ${DOTFILES_PATH:-unset} == 'unset' ]]; then
	export DOTFILES_PATH="$HOME/.dotfiles"
fi

if [[ -d ${DOTFILES_PATH} ]]; then
	echo "$DOTFILES_PATH already exists. Aborting."
fi 

git clone https://github.com/GoodGuide/dotfiles.git "${DOTFILES_PATH}"

cd "${DOTFILES_PATH}"

git submodule update --init --recursive

echo -e "\n[ link.sh ]\n"
./link.sh

echo -e "\n[ setup.sh ]\n"
./setup.sh
