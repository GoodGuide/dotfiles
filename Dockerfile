# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2:
FROM quay.io/goodguide/base:latest

RUN apt-get update \
 && apt-get install \
      build-essential \
      exuberant-ctags \
      git \
      python \
      python-dev \
      zsh \
 # Set shell to zsh
 && usermod -s /usr/bin/zsh root

ENV DOTFILES_PATH /root/.dotfiles
ADD . $DOTFILES_PATH
RUN cd $DOTFILES_PATH \
 && $DOTFILES_PATH/link.sh \
 && $DOTFILES_PATH/setup.sh \

VOLUME ["/root/.dotfiles"]

WORKDIR /root
