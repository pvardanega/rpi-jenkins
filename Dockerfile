FROM resin/rpi-raspbian:latest
MAINTAINER Pierre-Jean Vardanega <pierrejean.vardanega@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV JENKINS_VERSION 2.64
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

RUN apt-get -y update \
  && apt-get install -y --no-install-recommends curl git maven

# Install docker
RUN curl -sSL https://get.docker.com | sh

# The special trick here is to download and install the Oracle Java 8 installer from Launchpad.net
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get --yes update
# Make sure the Oracle Java 8 license is pre-accepted, and install Java 8
RUN    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
       echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
       apt-get --yes install curl oracle-java8-installer libapparmor-dev ; apt-get clean

RUN curl -fL -o /opt/jenkins.war https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/{$JENKINS_VERSION}/jenkins-war-{$JENKINS_VERSION}.war
RUN adduser --disabled-login --no-create-home --gecos "" --shell /bin/sh jenkins
RUN mkdir ${JENKINS_HOME}
RUN chown -R jenkins:jenkins ${JENKINS_HOME}
RUN chmod 644 /opt/jenkins.war

# Fix docker-client issue with libjffi for arm: https://github.com/spotify/docker-client/issues/477
RUN apt-get install -y texinfo build-essential ant
RUN cd /tmp
RUN git clone https://github.com/jnr/jffi.git
RUN cd jffi
RUN ant jar
RUN cd build/jni
RUN cp libjffi-1.2.so /usr/lib
RUN chmod 644 /usr/lib/libjffi-1.2.so

VOLUME ${JENKINS_HOME}

WORKDIR ${JENKINS_HOME}

EXPOSE 8080 ${JENKINS_SLAVE_AGENT_PORT}

CMD ["sh", "-c", "java -jar /opt/jenkins.war"]