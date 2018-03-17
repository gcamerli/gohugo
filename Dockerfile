FROM debian:jessie

LABEL maintainer="Gius. Camerlingo <gcamerli@gmail.com>"

# Add name to Docker image
ENV NAME=gohugo

# Set environment variables
ENV TERM=xterm
ENV DEBIAN_FRONTEND=noninteractive
ENV RUNLEVEL=1

# Update source list
RUN echo "deb http://deb.debian.org/debian jessie main contrib non-free" > /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org jessie/updates main contrib non-free" >> /etc/apt/sources.list

# Update Debian
RUN apt-get update
RUN apt-get install -y \
  apt-utils \
  xterm \
  build-essential \
  libtool \
  curl \
  vim \
  git \
  python-pygments \
  golang

# Set no password for docker user
RUN apt-get install -y sudo
RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create a new user
RUN useradd -ms /bin/zsh docker
USER docker
ENV HOME=/home/docker
WORKDIR $HOME

# Download Hugo
ENV HUGO_DEB=https://github.com/gohugoio/hugo/releases/download/v0.37/hugo_0.37_Linux-64bit.deb
ADD $HUGO_DEB /tmp
RUN sudo dpkg -i /tmp/hugo_*.deb

# Hugo static blog directory
RUN mkdir blog
WORKDIR $HOME/blog

# Docker network settings
ENV VIRTUAL_HOST="http://docker.local:1313"

# Create new Hugo blog
RUN hugo new site $HOME/blog
RUN git clone --progress --verbose https://github.com/calintat/minimal.git themes/minimal

# Serve Hugo
RUN hugo -t minimal
RUN cp themes/minimal/exampleSite/config.toml .
RUN cp -r themes/minimal/exampleSite/content/* content
CMD hugo --renderToDisk=true --watch=true --bind="0.0.0.0" --baseURL="${VIRTUAL_HOST}" server
