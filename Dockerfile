#Base on Ubuntu 
FROM ubuntu:20.04
#Based from cloud SDK
#FROM google/cloud-sdk:latest
ENV DEBIAN_FRONTEND=noninteractive
#Install Cloud-sdk
RUN apt-get update && apt-get install -y --no-install-recommends curl apt-transport-https ca-certificates gnupg &&\
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - &&\
    apt-get update -y &&\
    apt-get install google-cloud-sdk -y 
#    apt-get install google-cloud-sdk-pubsub-emulator &&\ 
#    apt-get --only-upgrade install -y google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-java google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-spanner-emulator kubectl google-cloud-sdk-firestore-emulator google-cloud-sdk-datalab google-cloud-sdk-app-engine-python-extras google-cloud-sdk-cbt google-cloud-sdk-app-engine-python


#Install needed apps
RUN apt-get install -y --no-install-recommends cmake postgresql postgresql-contrib python3 python3-setuptools python3-dev python3-pip ssh-client git wget make gcc g++

## Install Cloud SQL Proxy

WORKDIR /usr/src/app
RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy &&\
    /bin/bash -c 'chmod +x cloud_sql_proxy'

## Manual CMake Install
#RUN apt-get install -y build-essential libssl-dev &&\
#    wget https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5.tar.gz &&\
#    tar -zxvf cmake-3.16.5.tar.gz &&\
#    cd cmake-3.16.5 &&\
#    ./bootstrap &&\
#    make &&\
#    make install 

## Setup ESP-IDF
RUN apt-get install -y --no-install-recommends flex bison gperf ninja-build ccache libffi-dev libssl-dev dfu-util &&\
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 &&\
    mkdir -p /home/root/esp &&\
    cd /home/root/esp &&\
    git clone --recursive https://github.com/espressif/esp-idf.git &&\ 
    esp-idf/install.sh

## Setup SQL
COPY create.sql ./
USER postgres
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER hm_user WITH SUPERUSER PASSWORD 'hm1';" &&\
    createdb -O hm_user testing_db &&\
    echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/12/main/pg_hba.conf &&\
    echo "host all all ::/0 md5" >> /etc/postgresql/12/main/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf
EXPOSE 5432

# USER root
# ENV PGPASSFILE ~/.pgpass
# RUN touch ~/.pgpass && chmod 600 ~/.pgpass && echo "localhost:5432:*:hm_user:hm1" > ~/.pgpass 
# RUN psql -h localhost testing_db

## Install requirements
## Upgrade pip first to speedup install for some packages
COPY requirements.txt ./
RUN pip3 install --upgrade pip &&\
    pip3 install -r requirements.txt
WORKDIR /usr/src/app
USER root
