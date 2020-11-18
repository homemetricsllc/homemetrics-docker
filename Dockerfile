#Based from cloud SDK
FROM google/cloud-sdk:latest

#Install needed apps
RUN apt-get update && apt-get install -y postgresql postgresql-contrib python3-dev python3-pip ssh-client git wget google-cloud-sdk-pubsub-emulator && apt-get --only-upgrade install google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-java google-cloud-sdk-skaffold google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-minikube google-cloud-sdk-spanner-emulator kubectl google-cloud-sdk google-cloud-sdk-anthos-auth google-cloud-sdk-pubsub-emulator google-cloud-sdk-firestore-emulator google-cloud-sdk-kpt google-cloud-sdk-datalab google-cloud-sdk-app-engine-python-extras google-cloud-sdk-app-engine-grpc google-cloud-sdk-cloud-build-local google-cloud-sdk-kind google-cloud-sdk-cbt google-cloud-sdk-app-engine-python


WORKDIR /usr/src/app

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && /bin/bash -c 'chmod +x cloud_sql_proxy'


COPY requirements.txt ./

RUN pip3 install -r requirements.txt
