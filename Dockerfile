FROM ubuntu:18.04 as build

# update this to blow away cached layers
ENV REFRESHED_AT=2020-01-13 \
      LANGUAGE=en_US.UTF-8 \
      LANG=en_US.UTF-8 \
      LC_ALL=en_US.UTF-8 \
      TERM=xterm

# Install base package
RUN apt-get -y update

# try to get npm install to work without errors
RUN apt-get install -y --no-install-recommends ca-certificates curl

#This command adds a signing key for NodeSource to your system,
#creates a source repository file for apt, installs all the required packages,
#and refreshes the apt cache
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -

# Required to install erlang, also install npm and node required for phoenix assets
RUN apt-get install -y --no-install-recommends wget git build-essential gnupg apt-utils nodejs locales

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment; \
      echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen; \
      echo "LANG=en_US.UTF-8" > /etc/locale.conf; \
      locale-gen en_US.UTF-8

# Install Erlang
RUN wget --no-check-certificate https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && dpkg -i erlang-solutions_2.0_all.deb
RUN apt-get -y update
RUN apt-get -y install esl-erlang

# Install Elixir
RUN apt-get -y install elixir

# Ensure latest versions of Hex/Rebar are installed on build
ONBUILD RUN mix do local.hex --force, local.rebar --force
