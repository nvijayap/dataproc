#!/usr/bin/env bash

# ------------------
# create_destroy.sh
# ------------------

cat $0 # self-describe at runtime

if [ ! -f ~/.dataproc/config.json ]; then
  echo "
  . Please create ~/.dataproc/config.json on these lines ...
{
  "project": "the-project-id",
  "region": "the-region",
  "zone": "the-zone",
  "keyfile": "~/.dataproc/the-key-file.json",
  "cluster": "dataproc-cluster-name",
}
  "
  exit 1
fi

type jq >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "\n . Please 'brew install jq' and then retry\n"
  exit 2
fi

sbt clean package || exit 3

KEYFILE=`jq -r .keyfile ~/.dataproc/config.json`
CLUSTER=`jq -r .cluster ~/.dataproc/config.json`
PROJECT=`jq -r .project ~/.dataproc/config.json`
REGION=`jq -r .region ~/.dataproc/config.json`
ZONE=`jq -r .zone ~/.dataproc/config.json`
JAR_PATH=`find . -name \*.jar`
JAR_NAME=`basename $JAR_PATH`

sed "
s|KEYFILE|$KEYFILE|g
s|CLUSTER|$CLUSTER|g
s|PROJECT|$PROJECT|g
s|REGION|$REGION|g
s|ZONE|$ZONE|g
s|JAR_PATH|$JAR_PATH|g
s|JAR_NAME|$JAR_NAME|g
" main.tf.template >main.tf

echo -e "\n . Validating ...\n"

terraform validate || exit 1

echo -e "\n . Creating ...\n"

terraform apply -auto-approve || exit 2

echo -e "\n . Sleeping for a while (giving time for job to complete) ...\n"

sleep 120

echo -e "\n . Destroying ...\n"

terraform destroy -auto-approve || exit 3

echo -e "\n . Done\n"
