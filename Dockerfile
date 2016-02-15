FROM jenkins
MAINTAINER Jeffery Utter "jeff.utter@firespring.com"

USER root
RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -aG docker jenkins

RUN curl -sSL https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`/bin/uname -s`-`/bin/uname -m` > /usr/local/bin/docker-compose && /bin/chmod +x /usr/local/bin/docker-compose

USER jenkins
