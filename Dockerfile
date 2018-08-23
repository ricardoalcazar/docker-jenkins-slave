##
#
# Created: R. Alcazar 8/20/2018
#
##

FROM centos:7
LABEL maintainer="ricardo.d.alcazar@gmail.com"

# Update OS
RUN yum update -y && \
	yum clean all

# Install packages
RUN yum install -y git && \
	yum install -y wget && \
	yum install -y java-1.8.0-openjdk && \
	yum install -y sudo && \ 
	yum clean all

# Setup user
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

ENV JENKINS_HOME /home/${user}

# Jenkins is run with user "jenkins", uid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
RUN chown ${user}:${group} /home/${user}

# Add jenkins to the sudoers list
RUN echo "${user}	ALL=(ALL)	ALL" >> etc/sudoers

# Copy network files to help with server resolution
# COPY resolv.conf /etc/resolv.conf





