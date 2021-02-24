FROM 'ubuntu:18.04'

# Add JDK and tcServer packages downloaded from Tanzu Network repository
COPY pivotal-tc-server_4.1.6-RELEASE_all.deb /tmp
COPY openjdk-jdk-1.8.0_242-bionic.tar.gz /tmp
COPY pivotal-tc-runtime-9.0.43.A-4.1.6.RELEASE.deb /tmp

# Unpack and configure packages 
RUN dpkg -i /tmp/pivotal-tc-server_4.1.6-RELEASE_all.deb /tmp/pivotal-tc-runtime-9.0.43.A-4.1.6.RELEASE.deb
RUN mkdir -p /opt/java/openjdk-jdk-1.8.0_242 && \
    tar xzf /tmp/openjdk-jdk-1.8.0_242-bionic.tar.gz -C /opt/java/openjdk-jdk-1.8.0_242

RUN touch /instance-descriptor.yaml

ENV TCSERVER_HOME=/opt/pivotal/tcserver/standard
ENV TCSERVER_RUNTIMES_DIRECTORY=/opt/pivotal/tcserver/runtimes
ENV TCSERVER_INSTANCES_DIRECTORY=/var/opt/pivotal/tcserver/instances

ENV JAVA8_HOME=/opt/java/openjdk-jdk-1.8.0_242
ENV JAVA_HOME=$JAVA8_HOME
ENV PATH=$TCSERVER_HOME:$JAVA_HOME/bin:$PATH

USER tcserver

EXPOSE 8080

CMD $TCSERVER_HOME/tcserver create-from-file /instance-descriptor.yaml --run
