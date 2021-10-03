#!/usr/bin/env bash

# -------------
# functions.sh
# -------------

config=~/.dataproc/config.json

if [ ! -f $config ]; then
  echo "
  . Please create $config on these lines ...
{
  "zone": "the-zone",
  "cluster": "dataproc-cluster-name",
  "keyfile": "/full/path/of/the-key-file"
}
  "
  exit 1
fi

abort() { echo -e "\n . $1\n"; exit $2; }

type brew >/dev/null 2>&1 || abort "Please install brew and then retry" 2

type jq >/dev/null 2>&1 || abort "Please 'brew install jq' and then retry" 3

type sbt >/dev/null 2>&1 || abort "Please 'brew install sbt' and then retry" 4

type gcloud >/dev/null 2>&1 || abort "Please install google-cloud-sdk and then retry" 5

PROJECT=`gcloud config get-value project`

[ "$PROJECT" == "" ] && abort "Your gcloud config is not set properly; Unable to get the value for project" 6

REGION=`gcloud config get-value dataproc/region`

[ "$PROJECT" == "" ] && abort "Your gcloud config is not set properly; Unable to get the value for dataproc/region" 7

ZONE=`jq -r .zone ~/.dataproc/config.json`
CLUSTER=`jq -r .cluster ~/.dataproc/config.json`
KEYFILE=`jq -r .keyfile ~/.dataproc/config.json`

create_jar() {
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
  JAR_PATH=`find . -name \*.jar`
  JAR_NAME=`basename $JAR_PATH`
}
