#!/usr/bin/env bash

# ---------------------------------------------------------------
# create_cluster.sh - creates a dataproc cluster using terraform
# ---------------------------------------------------------------

trap "/bin/rm -fr `dirname $0`/../tf" SIGINT SIGTERM EXIT

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

cd `dirname $0`/..

if [ `find . -name \*.jar | wc -l` -eq 1 ]; then
  JAR_FILE=`find . -name \*.jar`
  echo "JAR_FILE: $JAR_FILE"
  SRC_FILE=`find . -name \*.scala`
  echo "SRC_FILE: $SRC_FILE"
  if [ $SRC_FILE -nt $JAR_FILE ]; then
    echo -e "\n . Source file is newer than jar file so recreating jar file\n"
    scripts/create_jar.sh
  fi
else
  echo -e "\n . Jar file not found so creating it\n"
  scripts/create_jar.sh
fi

KEYFILE=`jq -r .keyfile ~/.dataproc/config.json`
CLUSTER=`jq -r .cluster ~/.dataproc/config.json`

PROJECT=`jq -r .project ~/.dataproc/config.json`
REGION=`jq -r .region ~/.dataproc/config.json`
ZONE=`jq -r .zone ~/.dataproc/config.json`

JAR_PATH=`find . -name \*.jar`
JAR_NAME=`basename $JAR_PATH`

mkdir tf

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

echo -e "\n . Done\n"
