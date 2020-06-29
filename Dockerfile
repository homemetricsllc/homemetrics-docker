#Based from cloud SDK
FROM google/cloud-sdk:latest

#Install needed apps
RUN apt-get update && apt-get install -y python3-dev python3-pip ssh-client git

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip3 install -r requirements.txt
