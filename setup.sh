#!/bin/bash
# vim: set noexpandtab tabstop=4 softtabstop=4 shiftwidth=4:
set -e -u

if [[ -d ${HOME}/.vim/bundle/ctrlp-cmatcher ]]; then
	echo "[ Compiling C ext for ctrlp-cmatcher ]"
	(
		cd "${HOME}/.vim/bundle/ctrlp-cmatcher"
		./install.sh
	)
fi
