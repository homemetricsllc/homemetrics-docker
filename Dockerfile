#Based from cloud SDK
FROM google/cloud-sdk:latest

#Install needed apps
RUN apt-get update && apt-get install -y python3-dev python3-pip ssh-client git wget


WORKDIR /usr/src/app

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy &&
    /bin/bash -c 'chmod +x cloud_sql_proxy'

COPY requirements.txt ./

RUN pip3 install -r requirements.txt
