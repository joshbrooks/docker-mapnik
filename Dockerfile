FROM ubuntu:latest
MAINTAINER Joshua Brooks "josh.vdbroek@gmail.com"
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
RUN update-locale LANG=C.UTF-8

# Use docker host's apt-cache-ng server
RUN route -n | awk '/^0.0.0.0/ {print $2}' > /tmp/host_ip.txt; nc -zv `cat /tmp/host_ip.txt` 3142 &> /dev/null && if [ $? -eq 0 ]; then echo "Acquire::http::Proxy \"http://$(cat /tmp/host_ip.txt):3142\";" > /etc/apt/apt.conf.d/30proxy; echo "Proxy detected on docker host - using for this build"; fi

# Essential stuffs
RUN apt-get update && apt-get -qq install -y --no-install-recommends \
	build-essential \
	sudo \
	software-properties-common \
	curl

# Boost
RUN 	apt-get -qq install -y --no-install-recommends \
	libboost-dev \
	libboost-filesystem-dev \
	libboost-program-options-dev \
	libboost-python-dev \
	libboost-regex-dev \
	libboost-system-dev \
	libboost-thread-dev

# Mapnik dependencies
RUN 	apt-get -qq install -y --no-install-recommends \
	libicu-dev \
	libtiff4-dev \
	libfreetype6-dev \
	libpng12-dev \
	libxml2-dev \
	libproj-dev \
	libsqlite3-dev \
	libgdal-dev \
	libcairo-dev \
	python-cairo-dev \
	postgresql-contrib \
	libharfbuzz-dev

RUN 	apt-get -qq install -y --no-install-recommends \
	python-pip \
	python-dev \
	libjpeg8 \
	zlib1g \
	libtiff5 \
	libfreetype6 \
	liblcms2-2 \
	libwebp5 \
	libtk8.6 \
	libjpeg8-dev \
	zlib1g-dev \
	libtiff5-dev \
	libfreetype6-dev \
	libgeos-c1 \
	libgeos-3.4.2 \
	libgeos-dev && \
	apt-get clean

RUN 	apt-get -qq install -y --no-install-recommends \
	memcached libmemcached-dev 

RUN if [ -f "/etc/apt/apt.conf.d/30proxy" ]; then rm /etc/apt/apt.conf.d/30proxy; fi

# If running from a local server you might use pip2pi to build a "simple" cache in ./pip
# COPY 	pip /tmp/pip/
# RUN 	ls -l /tmp/pip
# COPY 	requirements.txt /tmp/requirements.txt 
# RUN	pip install --index-url=file:///tmp/pip/simple/ -r /tmp/requirements.txt

# Running from elsewhere
RUN	pip install -r /tmp/requirements.txt

RUN sed -i 's/Image.fromstring/Image.frombytes/' /usr/local/lib/python2.7/dist-packages/TileStache/Mapnik.py
RUN sed -i 's/Image.fromstring/Image.frombytes/' /usr/local/lib/python2.7/dist-packages/TileStache/Pixels.py

CMD ["/bin/bash"]
