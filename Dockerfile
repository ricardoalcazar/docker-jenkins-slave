##
#
# Modified: R. Alcazar 8/22/2018
#
##

FROM ubuntu:18.04
LABEL maintainer="ricardo.d.alcazar@gmail.com"

# Update packages
RUN apt-get update -y && \
    apt-get upgrade -y

# Install packages
RUN apt-get install -y git && \
    apt-get install -y wget && \
	apt-get install -y openjdk-8-jdk && \
	apt-get install -y sudo && \
	apt-get install -y maven && \
	apt-get install -y unzip

# Setup user
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# ANDROID SDK
ARG SDK=https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

# GRADLE
ARG GRADLE=https://services.gradle.org/distributions/gradle-3.4.1-bin.zip

# Environment
ENV JENKINS_HOME /home/${user}
ENV ANDROID_HOME $JENKINS_HOME/android_home
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV GRADLE_HOME /opt/gradle
ENV PATH "${PATH}:/opt/gradle/gradle-3.4.1/bin"


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
RUN echo y | ./tools/bin/sdkmanager "build-tools;27.0.3" && \
	echo y | ./tools/bin/sdkmanager "platforms;android-27"
RUN rm sdk-tools-linux-4333796.zip
RUN chown -R ${user}:${group} $ANDROID_HOME

# Create Gradle dir
RUN mkdir $GRADLE_HOME
WORKDIR $GRADLE_HOME
RUN wget ${GRADLE}
RUN unzip gradle-3.4.1-bin.zip
RUN rm gradle-3.4.1-bin.zip

WORKDIR $JENKINS_HOME

