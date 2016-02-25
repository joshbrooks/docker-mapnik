FROM ubuntu:latest

MAINTAINER Joshua Brooks "josh.vdbroek@gmail.com"
ENV DEBIAN_FRONTEND=noninteractive

# Use docker host's apt-cache-ng server
# ADD ./apt.conf /etc/apt/apt.conf

RUN 	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y python-pip && \
	apt-get clean

RUN 	pip install mapnik

