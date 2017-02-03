###################################################
# Dockerfile for Long Ranger
###################################################

# Based on...
FROM centos:7

# File Author / Maintainer
MAINTAINER Eddie Belter

# Install some utilities
RUN yum install -y \
	file \
	git \
	sssd-client \
	which \
	unzip

# Install bcl2fastq
RUN cd /tmp/ && \
	curl -o bcl2fastq2-v2.17.1.14-Linux-x86_64.zip ftp://webdata2:webdata2@ussd-ftp.illumina.com/downloads/software/bcl2fastq/bcl2fastq2-v2.17.1.14-Linux-x86_64.zip && \
	unzip bcl2fastq2-v2.17.1.14-Linux-x86_64.zip && \
	yum -y --nogpgcheck localinstall bcl2fastq2-v2.17.1.14-Linux-x86_64.rpm && \
	rm bcl2fastq2-v2.17.1.14-Linux-x86_64.rpm bcl2fastq2-v2.17.1.14-Linux-x86_64.zip
	
# Install longranger
RUN cd /opt/ && \
	git clone https://github.com/genome-vendor/10Xgenomics-longranger.git --branch v2.1.2 --single-branch longranger-2.1.2/ && \
	cd longranger-2.1.2/ && \
	rm -rf .git

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
