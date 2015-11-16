# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2:
FROM ubuntu:15.10

# Set apt mirror
RUN sed 's:archive.ubuntu.com/ubuntu/:mirrors.rit.edu/ubuntu-archive/:' -i /etc/apt/sources.list

# enable backports and others off by default
RUN sed 's/^#\s*deb/deb/' -i /etc/apt/sources.list

# never install recommends automatically
RUN echo 'Apt::Install-Recommends "false";' > /etc/apt/apt.conf.d/docker-no-recommends

# Enable automatic preference to use backport
RUN echo 'Package: *'                      >> /etc/apt/preferences \
 && echo 'Pin: release a=wily-backports'   >> /etc/apt/preferences \
 && echo 'Pin-Priority: 500'               >> /etc/apt/preferences

# Install aptitude and add-apt-repository
RUN apt-get update \
 && apt-get install -y \
      aptitude \
      software-properties-common \
 && aptitude autoclean

# Set up PPAs
RUN add-apt-repository ppa:git-core/ppa

# Install base packages
RUN aptitude update \
 && aptitude install -y \
      apt-transport-https \
      build-essential \
      curl \
      exuberant-ctags \
      htop \
      ssh-client \
      git \
      manpages \
      zsh \
      mercurial \
      subversion \
      bzr \
      openssh-server \
      mosh \
 && aptitude autoclean

ENV PREFIX /usr/local

# Set up ssh server
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
RUN chmod 0700 /root/.ssh
EXPOSE 22

# Install Golang
RUN cd /tmp \
 && curl -L -o go.tgz https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz \
 && shasum go.tgz | grep -q 46eecd290d8803887dec718c691cc243f2175fe0 \
 && tar -xvz -C "$PREFIX" -f go.tgz \
 && rm /tmp/go.tgz

ENV PATH   $PREFIX/go/bin:$PATH
ENV GOROOT $PREFIX/go
ENV GOPATH /root/gopath
RUN mkdir -p $GOPATH

# Install VIM
RUN aptitude install -y \
      libtcl8.6 \
      libselinux1 \
      libc6 \
      libtinfo5 \
      libacl1 \
      libgpm2 \
      libssl-dev \
      libncurses5-dev \
      python-dev \
 && aptitude autoclean
RUN git clone --depth=1 https://github.com/vim/vim.git /opt/vim \
 && cd /opt/vim \
 && git checkout v7.4.922 \
 && ./configure --with-features=huge --with-compiledby='docker@goodguide.com' \
 && make \
 && make install

# Install tmux
RUN aptitude install -y \
      libevent-dev \
 && aptitude autoclean
RUN git clone --depth=1 https://github.com/tmux/tmux.git /opt/tmux \
 && cd /opt/tmux \
 && git checkout 2.1
 && ./configure \
 && make \
 && make install

# Install Docker-client
RUN apt-key adv --keyserver 'hkp://p80.pool.sks-keyservers.net:80' --recv-keys '58118E89F3A912897C070ADBF76221572C52609D' \
 && echo 'deb https://apt.dockerproject.org/repo ubuntu-wily main' > /etc/apt/sources.list.d/docker.list \
 && aptitude update \
 && aptitude install -y docker-engine "linux-image-extra-$(uname -r)" \
 && aptitude autoclean

# Install docker-compose
RUN curl -fsSL -o /tmp/docker-compose "https://github.com/docker/compose/releases/download/1.5.1/docker-compose-`uname -s`-`uname -m`" \
 && shasum /tmp/docker-compose | grep -q '3856b2f1ea7d144e8433c7648583898097b34594' \
 && install -o root -g root /tmp/docker-compose "$PREFIX/bin/docker-compose" \
 && rm /tmp/docker-compose

# Install direnv
RUN curl -fsSL -o /tmp/direnv https://github.com/zimbatm/direnv/releases/download/v2.6.0/direnv.linux-amd64 \
 && shasum /tmp/direnv | grep -q 'ccc0b6569c39951d22ce7379b15fdffddb62d82d' \
 && install /tmp/direnv $PREFIX/bin/direnv \
 && rm /tmp/direnv

# install goodguide-git-hooks
RUN go get -u -v github.com/goodguide/goodguide-git-hooks

# install forego
RUN go get -u -v github.com/ddollar/forego

# Set up some environment
ENV HOME /root
ENV DOTFILES_PATH $HOME/dotfiles
ENV DOCKER_HOST 'unix:///var/run/docker.sock'

# Set shell to zsh
RUN usermod -s /usr/bin/zsh root

# Add actual config
ADD docker_runtime/entry.sh /usr/local/bin/entry_point
ADD . $DOTFILES_PATH
RUN cd $DOTFILES_PATH \
 && $DOTFILES_PATH/link.sh
 && $DOTFILES_PATH/setup.sh

ENV PATH $HOME/.local/bin:$PATH
ENV SHELL /usr/bin/zsh
WORKDIR /
VOLUME ["/root/code"]
CMD ["/usr/local/bin/entry_point"]
