FROM base/archlinux:latest
RUN pacman -Syu --noconfirm && pacman-db-upgrade && pacman -S --noconfirm \
    python2 \
    python2-pip \
    git && \
    pacman -Scc --noconfirm

ENV ALL_DOCKER_VERSIONS 1.6.0-rc4

RUN set -ex; \
    curl https://test.docker.com/builds/Linux/x86_64/docker-1.6.0-rc4 -o /usr/local/bin/docker-1.6.0-rc4; \
    chmod +x /usr/local/bin/docker-1.6.0-rc4

# Set the default Docker to be run
RUN ln -s /usr/local/bin/docker-1.6.0-rc4 /usr/local/bin/docker

RUN useradd -d /home/user -m -s /bin/bash user
WORKDIR /code/

ADD requirements.txt /code/
RUN pip2 install -r requirements.txt

ADD requirements-dev.txt /code/
RUN pip2 install -r requirements-dev.txt

ADD . /code/
RUN python2 setup.py install

RUN chown -R user /code/

ENTRYPOINT ["/usr/local/bin/docker-compose"]
