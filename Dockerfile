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
	curl -ko longranger-2.1.2.tar.gz "https://s3-us-west-2.amazonaws.com/10x.downloads/longranger-2.1.2.tar.gz?AWSAccessKeyId=AKIAJAZONYDS6QUPQVBA&Expires=1481185366&Signature=WqjleMfbCnjlCblQ%2FHvg%2B2dEkEY%3D" && \
	tar -xzf longranger-2.1.2.tar.gz && \
	rm longranger-2.1.2.tar.gz

# Add longranger to PATH
ENV PATH "${PATH}:/opt/longranger-2.1.2"
