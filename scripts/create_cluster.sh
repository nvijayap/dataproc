#!/usr/bin/env bash

# ---------------------------------------------------------------
# create_cluster.sh - creates a dataproc cluster using terraform
# ---------------------------------------------------------------

cd `dirname $0`/..

trap "/bin/rm -fr tf" SIGINT SIGTERM EXIT

source scripts/functions.sh

create_jar

KEYFILE=`jq -r .keyfile ~/.dataproc/config.json`
CLUSTER=`jq -r .cluster ~/.dataproc/config.json`

gcloud dataproc clusters list | grep -q $CLUSTER

if [ $? -eq 0 ]; then
  echo -e "\n$CLUSTER already exists\n"
  exit 1
fi

PROJECT=`jq -r .project ~/.dataproc/config.json`
REGION=`jq -r .region ~/.dataproc/config.json`
ZONE=`jq -r .zone ~/.dataproc/config.json`

JAR_PATH=`find . -name \*.jar`
JAR_NAME=`basename $JAR_PATH`

rm -fr tf; mkdir tf

sed "
s|KEYFILE|$KEYFILE|g
s|CLUSTER|$CLUSTER|g
s|PROJECT|$PROJECT|g
s|REGION|$REGION|g
s|ZONE|$ZONE|g
s|JAR_PATH|$JAR_PATH|g
s|JAR_NAME|$JAR_NAME|g
" templates/create_cluster.tf.template >tf/create_cluster.tf

cd tf

echo -e "\n . Initing ...\n"

terraform init || exit 1

echo -e "\n . Validating ...\n"

terraform validate || exit 1

echo -e "\n . Creating ...\n"

terraform apply -auto-approve || exit 2

echo -e "\n . Done creating cluster\n"
