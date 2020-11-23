#Based from cloud SDK
FROM google/cloud-sdk:latest

#Install needed apps
RUN apt-get update &&\
    apt-get install -y postgresql postgresql-contrib python3 python3-setuptools python3-dev python3-pip ssh-client git wget &&\
    apt-get install google-cloud-sdk-pubsub-emulator &&\ 
    apt-get --only-upgrade install google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-java google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-spanner-emulator kubectl google-cloud-sdk-firestore-emulator google-cloud-sdk-datalab google-cloud-sdk-app-engine-python-extras google-cloud-sdk-cbt google-cloud-sdk-app-engine-python


WORKDIR /usr/src/app

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy &&\
    /bin/bash -c 'chmod +x cloud_sql_proxy'

## Manual CMake Install
RUN apt-get install -y build-essential libssl-dev &&\
    wget https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5.tar.gz &&\
    tar -zxvf cmake-3.16.5.tar.gz &&\
    cd cmake-3.16.5 &&\
    ./bootstrap &&\
    make &&\
    make install 

## Setup ESP
WORKDIR /home/root/esp
RUN apt-get install -y flex bison gperf python python-pip python-setuptools ninja-build ccache libffi-dev libssl-dev dfu-util &&\
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
    echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/11/main/pg_hba.conf &&\
    echo "host all all ::/0 md5" >> /etc/postgresql/11/main/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf
EXPOSE 5432

# USER root
# ENV PGPASSFILE ~/.pgpass
# RUN touch ~/.pgpass && chmod 600 ~/.pgpass && echo "localhost:5432:*:hm_user:hm1" > ~/.pgpass 
# RUN psql -h localhost testing_db

COPY requirements.txt ./
RUN pip3 install -r requirements.txt
