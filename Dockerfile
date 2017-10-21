FROM python:3.6
MAINTAINER elvis@magic.io

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV WORKON_HOME /usr/local/python-venvs
ENV GOMAXPROCS 1

RUN mkdir -p /usr/local/python-venvs
RUN mkdir -p /usr/go/
ENV GOPATH /usr/go/

RUN apt-get update && apt-get install -y \
        autoconf automake libtool build-essential git

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y nodejs

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y -t jessie-backports gosu

RUN curl https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz \
        | tar xz \
        && mv go /usr/local/ \
        && ln /usr/local/go/bin/go /usr/bin/go

RUN git clone --depth=1 https://github.com/rbenv/ruby-build.git
RUN ./ruby-build/install.sh
RUN ruby-build 2.3.5 /usr/local/
RUN gem install rack:1.3 puma:3.10.0

RUN pip3 install vex
RUN vex --python=python3.6 -m bench pip install -U pip
RUN mkdir -p /var/lib/cache/pip

ADD servers /usr/src/servers
RUN cd /usr/src/servers && go build goecho.go && go build gohttp.go
RUN vex bench pip --cache-dir=/var/lib/cache/pip \
        install -r /usr/src/servers/requirements.txt

RUN vex bench pip freeze -r /usr/src/servers/requirements.txt

EXPOSE 25000

VOLUME /var/lib/cache
VOLUME /tmp/sockets

ENTRYPOINT ["/entrypoint"]

ADD entrypoint /entrypoint
