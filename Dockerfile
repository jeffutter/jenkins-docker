FROM jenkins
MAINTAINER Jeffery Utter "jeff.utter@firespring.com"

USER root

# Install uuid
RUN apt-get update \
    && apt-get install -y uuid default-libmysqlclient-dev libxml2-dev libxslt1-dev sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV JENKINS_HOME /var/lib/jenkins
RUN mkdir -p /var/lib/jenkins \
    && usermod -d /var/lib/jenkins jenkins \
    && chown -R jenkins:jenkins /var/lib/jenkins \
    && echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10_jenkins

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install Docker Compose
RUN curl -sSL https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/

# Install rvm/ruby/bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && curl -sSL https://get.rvm.io | bash -s stable
RUN bash -c " \
        source /etc/profile.d/rvm.sh \
        && rvm install 2.4 \
        && gem install bundler \
        && bundle config build.nokogiri --use-system-libraries \
        "

RUN usermod -aG rvm jenkins \
    && usermod -aG docker jenkins
USER jenkins
WORKDIR /var/lib/jenkins

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
