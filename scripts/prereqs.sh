#!/usr/bin/env bash

# -----------
# prereqs.sh
# -----------

cd `dirname $0`/..

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

type terraform >/dev/null 2>&1 || abort "Please 'brew install terraform' and then retry" 5

type gcloud >/dev/null 2>&1 || abort "Please install google-cloud-sdk and then retry" 6

PROJECT=`gcloud config get-value project`

[ "$PROJECT" == "" ] && abort "Your gcloud config is not set properly; Unable to get the value for project" 7

REGION=`gcloud config get-value dataproc/region`

[ "$PROJECT" == "" ] && abort "Your gcloud config is not set properly; Unable to get the value for dataproc/region" 8

ZONE=`jq -r .zone ~/.dataproc/config.json`
CLUSTER=`jq -r .cluster ~/.dataproc/config.json`
KEYFILE=`jq -r .keyfile ~/.dataproc/config.json`
