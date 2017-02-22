###################################################
# Dockerfile for Long Ranger
###################################################

# Based on...
FROM centos:7

# File Author / Maintainer
MAINTAINER Eddie Belter <ebelter@wustl.edu>

# Install some utilities
RUN yum install -y \
	file \
	git \
	sssd-client \
	which \
	unzip

# Install bcl2fastq
RUN cd /tmp/ && \
	git clone git://git/bcl2fastq.git --branch v2.17.1 --single-branch bcl2fastq && \
	cd bcl2fastq/ && \
	yum -y --nogpgcheck localinstall bcl2fastq2-v2.17.1.14-Linux-x86_64.rpm && \
	cd /tmp/ && \
	rm -rf bcl2fastq/

# Install longranger
RUN cd /tmp/ && \
	git clone git://git/10x-genomics-longranger --branch v2.1.3 --single-branch longranger && \
	cd longranger && \
	cp longranger-2.1.3.tar.gz /opt/ && \
	cd /opt/ && \
	tar zxf longranger-2.1.3.tar.gz && \
	rm -f longranger-2.1.3.tar.gz /longranger

# Shell script for CMD to setup ENV
RUN mkdir /opt/bin/ && \
	cd /tmp/ && \
	git clone https://github.com/genome/docker-longranger.git && \
	cd docker-longranger && \
	cp longranger /opt/bin && \
	cp lsf.template /opt/longranger-2.1.2/martian-cs/2.1.1/jobmanagers && \
	rm -rf /tmp/docker-longranger
RUN chmod 777 /opt/bin/longranger
RUN chmod 777 /opt/longranger-2.1.2/martian-cs/2.1.1/jobmanagers
RUN chmod 666 /opt/longranger-2.1.2/martian-cs/2.1.1/jobmanagers/*.template

# Entrypoint is the longranger wrapper scipt
ENTRYPOINT ["/opt/bin/longranger"]
