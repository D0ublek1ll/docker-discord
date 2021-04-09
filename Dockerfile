FROM debian:stretch

# Initial update & upgrade
RUN apt update \
    && apt upgrade -y \
    && apt -y install curl software-properties-common locales git \
    && useradd -d /home/container -m container

# Install gnupg2 & wget
RUN apt install -y gnupg2 wget

# NodeJS 12
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt -y install nodejs

# PHP 7.2
RUN apt install ca-certificates apt-transport-https \
	&& wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
	&& echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list \
    && apt update \
    && apt -y install php7.2 php7.2-cli php7.2-gd php7.2-mysql php7.2-pdo php7.2-mbstring php7.2-tokenizer php7.2-bcmath php7.2-xml php7.2-fpm php7.2-curl php7.2-zip

# OpenJDK 8
RUN apt -y install openjdk-8-jdk

# Python 2 & 3
RUN apt -y install build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev \
    libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev
RUN cd /usr/src \
    && wget https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz \
    && tar xzf Python-3.9.4.tgz \
    && cd Python-3.9.4 \
    && ./configure --enable-optimizations \
    && make altinstall
RUN pip3.9 install asyncio aiohttp discord image sys

# C Sharp & .NET
RUN apt -y install mono-runtime

# Lua 5.3
RUN apt -y install lua5.3

# FFmpeg
RUN apt -y install ffmpeg

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
