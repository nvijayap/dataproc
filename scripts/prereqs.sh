#!/usr/bin/env bash

# -----------
# prereqs.sh
# -----------

let ec=0

exitnow() { let ec=$ec+1; exit $ec; }

abort() { echo -e "\n . $1\n"; exitnow; }

export OS=`uname -s`

[ "$OS" != "Darwin" -a "$OS" != "Linux" ] && abort "Unsupported OS - $OS"

cd `dirname $0`/..

config=~/.dataproc/config.json

if [ ! -f $config ]; then
  echo "
  . Please create $config on these lines ...
{
  "zone": "the-zone",
  "cluster": "dataproc-cluster-name",
  "image_version": "dataproc-image-version",
  "keyfile": "/full/path/of/the-key-file"
}
  "
  abort
fi

type brew >/dev/null 2>&1 || abort "Please install brew and then retry"

type jq >/dev/null 2>&1 || abort "Please 'brew install jq' and then retry"

type sbt >/dev/null 2>&1

if [ $? -ne 0 ]; then
  if [ "$OS" == "Darwin" ]; then
    abort "Please 'brew install sbt' and then retry"
  else # Linux
    abort "Please 'sdk install sbt' and then retry"
  fi
fi

type terraform >/dev/null 2>&1 || abort "Please 'brew install terraform' and then retry"

type gcloud >/dev/null 2>&1 || abort "Please install google-cloud-sdk and then retry"

export PROJECT=`gcloud config get-value project`
if [ "$PROJECT" == "" ]; then
  abort "Your gcloud config is not set properly; Unable to get the value for project"
else
  echo -e "\nPROJECT: $PROJECT"
fi

export REGION=`gcloud config get-value dataproc/region`
if [ "$REGION" == "" ]; then
  abort "Your gcloud config is not set properly; Unable to get the value for dataproc/region"
else
  echo -e "\nREGION: $REGION"
fi

export ZONE=`jq -r .zone $config`
if [ -z $ZONE -o "$ZONE" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the zone field"
else
  echo -e "\nZONE: ${ZONE}"
fi

export CLUSTER=`jq -r .cluster $config`
if [ -z $CLUSTER -o "$CLUSTER" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the cluster field"
else
  echo -e "\nCLUSTER: ${CLUSTER}"
fi

export IMAGE_VERSION=`jq -r .image_version $config`
if [ -z $IMAGE_VERSION -o "$IMAGE_VERSION" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the image_version field"
else
  echo -e "\nIMAGE_VERSION: ${IMAGE_VERSION}"
fi

export KEYFILE=`jq -r '.keyfile' $config`
if [ -z $KEYFILE -o "$KEYFILE" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the keyfile field"
else
  echo -e "\nKEYFILE: ${KEYFILE}"
fi
