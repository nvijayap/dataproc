#!/usr/bin/env bash

# -----------
# prereqs.sh
# -----------

OS=`uname -s`

if [ "$OS" == "Darwin" ]; then
  :
elif [ "$OS" == "Linux" ]; then
  :
else
  echo -e "\nUnsupported OS - $OS\n"
  exit 1
fi

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
  exit 2
fi

abort() { echo -e "\n . $1\n"; exit $2; }

type brew >/dev/null 2>&1 || abort "Please install brew and then retry" 3

type jq >/dev/null 2>&1 || abort "Please 'brew install jq' and then retry" 4

type sbt >/dev/null 2>&1

if [ $? -ne 0 ]; then
  if [ "$OS" == "Darwin" ]; then
    abort "Please 'brew install sbt' and then retry" 5
  else # Linux
    abort "Please 'sdk install sbt' and then retry" 5
  fi
fi

type terraform >/dev/null 2>&1 || abort "Please 'brew install terraform' and then retry" 6

type gcloud >/dev/null 2>&1 || abort "Please install google-cloud-sdk and then retry" 7

PROJECT=`gcloud config get-value project`

if [ "$PROJECT" == "" ]; then
  abort "Your gcloud config is not set properly; Unable to get the value for project" 8
else
  echo -e "\nPROJECT: $PROJECT"
fi

REGION=`gcloud config get-value dataproc/region`

if [ "$REGION" == "" ]; then
  abort "Your gcloud config is not set properly; Unable to get the value for dataproc/region" 9
else
  echo -e "\nREGION: $REGION"
fi

ZONE=`jq -r .zone $config`
if [ -z $ZONE -o "$ZONE" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the zone field" 10
else
  echo -e "\nZONE: ${ZONE}"
fi

CLUSTER=`jq -r .cluster $config`
if [ -z $CLUSTER -o "$CLUSTER" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the cluster field" 11
else
  echo -e "\nCLUSTER: ${CLUSTER}"
fi

KEYFILE=`jq -r '.keyfile' $config`
if [ -z $KEYFILE -o "$KEYFILE" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the keyfile field" 12
else
  echo -e "\nKEYFILE: ${KEYFILE}"
fi
