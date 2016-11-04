FROM jenkins
MAINTAINER Jeffery Utter "jeff.utter@firespring.com"

USER root

# Install uuid
RUN apt-get update \
    && apt-get install -y uuid libmysqlclient-dev libxml2-dev libxslt1-dev supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -aG docker jenkins

# Install Docker Compose
RUN curl -sSL https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`/bin/uname -s`-`/bin/uname -m` > /usr/local/bin/docker-compose && /bin/chmod +x /usr/local/bin/docker-compose

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/

# Install rvm/ruby/bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && curl -sSL https://get.rvm.io | bash
RUN bash -c " \
        source /etc/profile.d/rvm.sh \
        && rvm install 2.2 \
        && gem install bundler \
        && bundle config build.nokogiri --use-system-libraries \
        "

RUN usermod -aG rvm jenkins
USER root
WORKDIR /var/jenkins_home
RUN chown -R jenkins:jenkins /var/jenkins_home

COPY start_jenkins.sh /usr/local/bin/start_jenkins.sh
COPY start_docker.sh /usr/local/bin/start_docker.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
