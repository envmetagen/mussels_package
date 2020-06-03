FROM nunofonseca/msi:latest

LABEL maintainer="nuno.fonseca at gmail.com"

RUN sudo dnf -y install gem
## install the nt db
RUN /opt/msi_install/bin/msi_install.sh -i  /opt/msi_install -x blast_db

WORKDIR /opt/msi

