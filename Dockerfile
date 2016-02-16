FROM jenkins
MAINTAINER Jeffery Utter "jeff.utter@firespring.com"

USER root

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -aG docker jenkins

# Install Docker Compose
RUN curl -sSL https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`/bin/uname -s`-`/bin/uname -m` > /usr/local/bin/docker-compose && /bin/chmod +x /usr/local/bin/docker-compose

# Install rvm/ruby/bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash
RUN bash -c "source /etc/profile.d/rvm.sh && rvm install 2.2 && gem install bundler"

RUN usermod -aG rvm jenkins
USER jenkins
