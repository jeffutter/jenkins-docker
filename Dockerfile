FROM jenkins
MAINTAINER Jeffery Utter "jeff.utter@firespring.com"

USER root
RUN curl -sSL https://get.docker.com/ | sh
USER jenkins
