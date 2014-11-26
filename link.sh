#!/bin/bash
# vim: set noexpandtab tabstop=4 shiftwidth=0:
set -e -u

DOTFILES_PATH=${DOTFILES_PATH:-"$HOME/.dotfiles"}

function create_link() {
	[[ -e "$DOTFILES_PATH/$1" ]] || (echo "Source does not exist"; exit 1)
	echo -n "  ~/$2 : "
	if [[ ! -e "$HOME/$2" ]]; then
		mkdir -p "$(dirname "$HOME/$2")"
		ln -sv "$DOTFILES_PATH/$1" "$HOME/$2"
	else
		echo "already exists"
	fi
}

echo "Installing to $HOME from ${DOTFILES_PATH}..."

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
