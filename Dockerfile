FROM ubuntu:18.04 as build

# Install base package
RUN apt-get -y update

# Update this to blow away cached layers
ENV REFRESHED_AT=2019-12-02 \
      TERM=xterm

# Required to install erlang
RUN apt-get install -y --no-install-recommends wget git build-essential gnupg apt-utils nodejs npm locales
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
