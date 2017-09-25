############################################################
# Dockerfile to run a Django-based web application
# Based on an Ubuntu Image
############################################################

# Set the base image to use to Ubuntu
FROM ubuntu:16.04

MAINTAINER Luis del Rio

# Directory in container for all project files
ENV DOCKYARD_SRVHOME=/srv
# Directory in container for project source files
ENV DOCKYARD_SRVPROJ=/srv/api

# Update the default application repository sources list
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y python python-pip

# Create application subdirectories
WORKDIR $DOCKYARD_SRVHOME
RUN mkdir media static logs
VOLUME ["$DOCKYARD_SRVHOME/media/", "$DOCKYARD_SRVHOME/logs/"]

RUN apt-get install libmysqlclient-dev -y
RUN apt-get install libpq-dev python-dev -y


# Install Python dependencies
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y

COPY requirements.txt $DOCKYARD_SRVPROJ/requirements.txt

RUN pip3 install --upgrade pip
RUN pip3 install -r $DOCKYARD_SRVPROJ/requirements.txt
RUN alias python=python3

# Port to expose
# EXPOSE 8000

# Copy entrypoint script into the image
WORKDIR $DOCKYARD_SRVPROJ
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]