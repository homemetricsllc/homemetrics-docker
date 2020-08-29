#Based from cloud SDK
FROM google/cloud-sdk:latest

#Install needed apps
RUN apt-get update && apt-get install -y python3-dev python3-pip ssh-client git wget


WORKDIR /usr/src/app

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
RUN /bin/bash -c 'chmod +x cloud_sql_proxy'

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn


COPY requirements.txt ./

RUN pip3 install -r requirements.txt
