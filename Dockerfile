# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2:
FROM ubuntu:15.10

# Set apt mirror
RUN sed 's:archive.ubuntu.com/ubuntu/:mirrors.rit.edu/ubuntu-archive/:' -i /etc/apt/sources.list

# enable backports and others off by default
RUN sed 's/^#\s*deb/deb/' -i /etc/apt/sources.list

# never install recommends automatically
RUN echo 'Apt::Install-Recommends "false";' > /etc/apt/apt.conf.d/docker-no-recommends
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/docker-assume-yes
RUN echo 'APT::Get::AutomaticRemove "true";' > /etc/apt/apt.conf.d/docker-auto-remove


# Enable automatic preference to use backport
RUN echo 'Package: *'                      >> /etc/apt/preferences \
 && echo 'Pin: release a=wily-backports'   >> /etc/apt/preferences \
 && echo 'Pin-Priority: 500'               >> /etc/apt/preferences

# Install aptitude and add-apt-repository
RUN apt-get update \
 && apt-get install -y \
      aptitude \
      software-properties-common \
 && apt-get clean

# Set up PPAs
RUN add-apt-repository ppa:git-core/ppa

# Install base packages
RUN apt-get update \
 && apt-get install -y \
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
 && apt-get clean

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

ENV GOROOT $PREFIX/go
RUN echo "export GOROOT=$GOROOT" >> /etc/profile
ENV GOPATH /root/gopath
RUN echo "export GOPATH=$GOPATH" >> /etc/profile
RUN mkdir -p $GOPATH
ENV PATH $PREFIX/go/bin:$PATH
RUN echo "export PATH=$GOPATH/bin:$GOROOT/bin:\$PATH" >> /etc/profile

# Install VIM
RUN apt-get install -y \
      libtcl8.6 \
      libselinux1 \
      libc6 \
      libtinfo5 \
      libacl1 \
      libgpm2 \
      libssl-dev \
      libncurses5-dev \
      python-dev \
 && apt-get clean
RUN git clone https://github.com/vim/vim.git /opt/vim \
 && cd /opt/vim \
 && git checkout v7.4.922 \
 && ./configure --with-features=huge --with-compiledby='docker@goodguide.com' \
 && make \
 && make install

# Install tmux
RUN apt-get install -y \
      libevent-dev \
      automake \
      pkg-config \
 && apt-get clean
RUN git clone https://github.com/tmux/tmux.git /opt/tmux \
 && cd /opt/tmux \
 && git checkout 2.1 \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install

# Install Docker-client
RUN apt-key adv --keyserver 'hkp://p80.pool.sks-keyservers.net:80' --recv-keys '58118E89F3A912897C070ADBF76221572C52609D' \
 && echo 'deb https://apt.dockerproject.org/repo ubuntu-wily main' > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y docker-engine \
 && apt-get clean

# Install docker-compose
RUN curl -fsSL -o /tmp/docker-compose "https://github.com/docker/compose/releases/download/1.5.1/docker-compose-`uname -s`-`uname -m`" \
 && shasum /tmp/docker-compose | grep -q '7134e022b69fca96d4fa7c3ea8a47c980941485e' \
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

# Set up some environment for SSH clients (ENV statements have no affect on ssh clients)
RUN echo "export DOCKER_HOST='unix:///var/run/docker.sock'" >> /etc/profile

# Set shell to zsh
RUN usermod -s /usr/bin/zsh root

# Add actual config
ADD docker_runtime/entry.sh /usr/local/bin/entry_point

ENV DOTFILES_PATH /root/.dotfiles
ADD . $DOTFILES_PATH
RUN cd $DOTFILES_PATH \
 && $DOTFILES_PATH/link.sh \
 && $DOTFILES_PATH/setup.sh

WORKDIR /
VOLUME ["/root/code"]
CMD ["/usr/local/bin/entry_point"]
