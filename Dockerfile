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
	sssd-client \
	which \
	unzip

# Install bcl2fastq
RUN cd tmp/ && \
	curl -o bcl2fastq2-v2.17.1.14-Linux-x86_64.zip ftp://webdata2:webdata2@ussd-ftp.illumina.com/downloads/software/bcl2fastq/bcl2fastq2-v2.17.1.14-Linux-x86_64.zip && \
	unzip bcl2fastq2-v2.17.1.14-Linux-x86_64.zip && \
	yum -y --nogpgcheck localinstall bcl2fastq2-v2.17.1.14-Linux-x86_64.rpm && \
	rm bcl2fastq2-v2.17.1.14-Linux-x86_64.rpm bcl2fastq2-v2.17.1.14-Linux-x86_64.zip
	
# Install longranger
#  unfortunately, the expires param here makes the url invalid after a certain time.
RUN cd opt/ && \
	curl -ko longranger-2.1.2.tar.gz "https://s3-us-west-2.amazonaws.com/10x.downloads/longranger-2.1.2.tar.gz?AWSAccessKeyId=AKIAJAZONYDS6QUPQVBA&Expires=1481712226&Signature=q3tgMw%2BcE7EBfs6FQfQS3LzCoDc%3D" && \
	tar -xzf longranger-2.1.2.tar.gz && \
	rm longranger-2.1.2.tar.gz

# Shell script for CMD to setup ENV
RUN yum install -y \
	git
RUN mkdir /opt/bin/ && \
	cd /tmp/ && \
	git clone git@github.com:genome/docker-longranger && \
	cd docker-longranger && \
	cp longranger /opt/bin && \
	rm -rf /tmp/docker-longranger

COPY longranger /opt/bin/
RUN chmod 777 /opt/bin/longranger

# Entrypoint is the longranger wrapper scipt
ENTRYPOINT ["/opt/bin/longranger"]
