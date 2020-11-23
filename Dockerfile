#Based from cloud SDK
FROM google/cloud-sdk:latest

#Install needed apps
RUN apt-get update && apt-get install -y postgresql postgresql-contrib python3 python3-setuptools python3-dev python3-pip ssh-client git wget 
RUN apt-get update && apt-get install google-cloud-sdk-pubsub-emulator && apt-get --only-upgrade install google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-java google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-spanner-emulator kubectl google-cloud-sdk-firestore-emulator google-cloud-sdk-datalab google-cloud-sdk-app-engine-python-extras google-cloud-sdk-cbt google-cloud-sdk-app-engine-python


WORKDIR /usr/src/app

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy &&\
    /bin/bash -c 'chmod +x cloud_sql_proxy'

## Setup ESP
RUN apt-get install -y flex bison gperf python python-pip python-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN mkdir -p ~/esp && cd ~/esp
WORKDIR ~/esp
RUN git clone --recursive https://github.com/espressif/esp-idf.git && esp-idf/install.sh

## Setup SQL
COPY create.sql ./
USER postgres
RUN /etc/init.d/postgresql start &&\
  psql --command "CREATE USER hm_user WITH SUPERUSER PASSWORD 'hm1';" &&\
  createdb -O hm_user testing_db

RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/11/main/pg_hba.conf &&\
    echo "host all all ::/0 md5" >> /etc/postgresql/11/main/pg_hba.conf &&\
    echo "listen_addresses='*'" >> /etc/postgresql/11/main/postgresql.conf
EXPOSE 5432

# USER root
# ENV PGPASSFILE ~/.pgpass
# RUN touch ~/.pgpass && chmod 600 ~/.pgpass && echo "localhost:5432:*:hm_user:hm1" > ~/.pgpass 
# RUN psql -h localhost testing_db

COPY requirements.txt ./
RUN pip3 install -r requirements.txt
