##
#
# Modified: R. Alcazar 8/30/2018
#
##

FROM centos:7
LABEL maintainer="ricardo.d.alcazar@gmail.com"

# Update packages
RUN yum update -y && \
    yum clean all

# Install packages
RUN yum install -y wget && \
	yum install -y java-1.8.0-openjdk-devel && \
	yum install -y python && \
	yum install -y sudo && \
	yum install -y unzip && \
	yum clean all

# Install latest git
RUN yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm && \
	yum install -y git

# Setup user
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# ANDROID SDK/NDK
ARG SDK=https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

# Environment
ENV JENKINS_HOME /home/${user}
ENV ANDROID_HOME $JENKINS_HOME/android_home
ENV JAVA_HOME /usr/lib/jvm/java-openjdk
RUN env

# Jenkins is run with user "jenkins", uid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
RUN chown ${user}:${group} /home/${user}

# Add jenkins to the sudoers list
RUN echo "${user}	ALL=(ALL)	ALL" >> etc/sudoers

# Create Android home-dir
RUN mkdir $ANDROID_HOME
RUN chown ${user}:${group} $ANDROID_HOME

# Download and extract Android SDK
WORKDIR $ANDROID_HOME
RUN wget ${SDK}
RUN unzip ./sdk-tools-linux-4333796.zip
RUN echo y | ./tools/bin/sdkmanager "build-tools;28.0.0" && \
	echo y | ./tools/bin/sdkmanager "platforms;android-28"

RUN rm sdk-tools-linux-4333796.zip
RUN chown -R ${user}:${group} $ANDROID_HOME

WORKDIR $JENKINS_HOME

