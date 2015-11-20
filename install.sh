#!/bin/bash
# vim: set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4:
set -e -u

{ # these braces ensure the script is fully downloaded before evaluation starts

if [[ ${DOTFILES_PATH:-unset} == 'unset' ]]; then
	export DOTFILES_PATH="$HOME/.dotfiles"
fi

if [[ ! -e ${DOTFILES_PATH} ]]; then
	git clone https://github.com/GoodGuide/dotfiles.git "${DOTFILES_PATH}"
else
	if [[ ${_DOTFILES_CLOBBER:-unset} == 'unset' ]]; then
		echo "$DOTFILES_PATH already exists. Aborting."
		exit 1
	fi
fi

cd "${DOTFILES_PATH}"

git submodule update --init --recursive

echo -e "\n[ link.sh ]\n"
./link.sh

echo -e "\n[ setup.sh ]\n"
./setup.sh

}
