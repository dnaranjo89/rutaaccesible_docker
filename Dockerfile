# Copyright 2013 Thatcher Peskens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04

MAINTAINER David Naranjo "dnaranjo89@gmail.com"

# Install required packages and remove the apt packages cache when done.

# TODO for some reason the volume is not created, it needs to be created when the container is run
# VOLUME ["/data"]

RUN apt-get update && apt-get install -y \
	git \
	python-pip \
	nginx \
	supervisor \
	libmysqlclient-dev \
    mysql-client \
  && rm -rf /var/lib/apt/lists/*

# install uwsgi now because it takes a little while
RUN pip install uwsgi

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-available/default
COPY flaskapp_uwsgi.conf /data/
COPY flaskapp_nginx.conf /etc/nginx/conf.d/
COPY flaskapp_supervisor.conf /etc/supervisor/conf.d/

# COPY requirements.txt and RUN pip install BEFORE adding the rest of your code, this will cause Docker's caching mechanism
# to prevent re-installinig (all your) dependencies when you made a change a line or two in your app.

#COPY app/requirements.txt /home/docker/code/app/
#RUN pip install -r /home/docker/code/app/requirements.txt



EXPOSE 80
CMD ["supervisord", "-n"]