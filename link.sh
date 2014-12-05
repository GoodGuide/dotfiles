#!/bin/bash
# vim: set noexpandtab tabstop=4 shiftwidth=0:
set -e -u

DOTFILES_PATH=${DOTFILES_PATH:-"$HOME/.dotfiles"}


function echo_red(){
	echo -e "\x1b[31m$1\x1b[0m"
}

function echo_green(){
	echo -e "\x1b[32m$1\x1b[0m"
}


function create_link() {
	[[ -e "$DOTFILES_PATH/$1" ]] || (echo "Source does not exist"; exit 1)
	local destination="$HOME/$2"
	local target="$DOTFILES_PATH/$1"
	echo -n "  ~/$2 : "
	if [[ -h "$destination" ]]; then
		local current="$(readlink "$destination")"
		if [[ $current = $target ]]; then
			echo_green "already exists correctly"
		else
			if [[ -r $current ]]; then
				echo_red "already exists as a symlink but does not point to $target"
			else
				echo_red "already exists as a broken symlink"
			fi
		fi
	elif [[ -e "$destination" ]]; then
		echo_red "already exists"
	else
		mkdir -p "$(dirname "$destination")"
		ln -sv "$target" "$destination"
	fi
}

echo -e "Installing to $HOME from ${DOTFILES_PATH}...\n"

create_link 'git/gitconfig' '.gitconfig'
create_link 'git/gitignore' '.gitignore'

create_link 'ruby/irbrc' '.irbrc'
create_link 'ruby/gemrc' '.gemrc'
create_link 'ruby/pryrc' '.pryrc'

create_link 'tmux/tmux.conf' '.tmux.conf'
create_link 'ackrc' '.ackrc'

create_link 'zsh/prezto' '.zprezto'
create_link 'zsh/prezto/runcoms/zlogin' '.zlogin'
create_link 'zsh/prezto/runcoms/zlogout' '.zlogout'
create_link 'zsh/prezto/runcoms/zpreztorc' '.zpreztorc'
create_link 'zsh/prezto/runcoms/zprofile' '.zprofile'
create_link 'zsh/prezto/runcoms/zshenv' '.zshenv'
create_link 'zsh/prezto/runcoms/zshrc' '.zshrc'

create_link 'vim/bundle' '.vim/bundle'
create_link 'vim/autoload' '.vim/autoload'
create_link 'vim/vimrc' '.vimrc'
mkdir -vp $HOME/.vim/backup

for bin in bin/*; do
	create_link "$bin" ".local/${bin}"
done
