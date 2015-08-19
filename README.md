# goodguide dotfiles

This is a baseline set of dotfiles. PR's welcome.

It currently includes settings for:

- vim
- ack
- git
- iTerm2
- ruby (gemrc, pryrc, irbrc)
- ssh
- tmux
- zsh (prezto)

## Installing

A decent amount of effort went into making this safe to run on an existing setup, but as always, make sure if you have anything configuring any of the aforementioned software, **back it up before running this**.

### for the daring:
```sh
bash <(curl -LsS https://github.com/GoodGuide/dotfiles/raw/master/install.sh)
```

### clone first:

```sh
git clone git@github.com:GoodGuide/dotfiles ~/.dotfiles
~/.dotfiles/install.sh
```

## Testing changes

The following one-liner will get you in a Zsh shell configured using these
dotfiles.

```bash
DOTFILES_PATH=$PWD (mkdir /tmp/foo; cd /tmp/foo; export HOME=/tmp/foo; $DOTFILES_PATH/install.sh; zsh)
```
