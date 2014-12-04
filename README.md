# goodguide dotfiles

This is a baseline set of dotfiles. PR's welcome.

## Testing changes

The following one-liner will get you in a Zsh shell configured using these
dotfiles.

```bash
DOTFILES_PATH=$PWD (mkdir /tmp/foo; cd /tmp/foo; export HOME=/tmp/foo; $DOTFILES_PATH/install.sh; zsh)
```
