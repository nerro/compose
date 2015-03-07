FROM base/archlinux:latest
RUN pacman -Syu --noconfirm && pacman-db-upgrade && pacman -S --noconfirm \
    python2 \
    python2-pip \
    git && \
    pacman -Scc --noconfirm
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
