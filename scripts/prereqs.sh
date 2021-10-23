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
  "standard_image_version_or_custom_image_url": "the-standard-dataproc-image-version or gs://bucket/custom-dataproc-image",
  "keyfile": "/full/path/of/the-key-file"
}
  "
  abort
fi

type jq >/dev/null 2>&1 || abort "Please install jq and then retry"

type sbt >/dev/null 2>&1 || abort "Please install sbt and then retry"

type terraform >/dev/null 2>&1 || abort "Please terraform and then retry"

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

export STANDARD_IMAGE_VERSION_OR_CUSTOM_IMAGE_URL=`jq -r .standard_image_version_or_custom_image_url $config`
if [ "$STANDARD_IMAGE_VERSION_OR_CUSTOM_IMAGE_URL" == "" -o "$STANDARD_IMAGE_VERSION_OR_CUSTOM_IMAGE_URL" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the standard_image_version_or_custom_image_url field"
fi

if [[ "$STANDARD_IMAGE_VERSION_OR_CUSTOM_IMAGE_URL" == gs://* ]]; then
  export CUSTOM_IMAGE_URL=$STANDARD_IMAGE_VERSION_OR_CUSTOM_IMAGE_URL
else
  export STANDARD_IMAGE_VERSION=$STANDARD_IMAGE_VERSION_OR_CUSTOM_IMAGE_URL
fi

if [ "$STANDARD_IMAGE_VERSION" == "" -o "$STANDARD_IMAGE_VERSION" == "null" ]; then
  echo -e "\nCUSTOM_IMAGE_URL: ${CUSTOM_IMAGE_URL}"
  (cd templates; ln -sf create_cluster_custom.tf.template create_cluster.tf.template)
elif [ "$CUSTOM_IMAGE_URL" == "" -o "$CUSTOM_IMAGE_URL" == "null" ]; then
  echo -e "\nSTANDARD_IMAGE_VERSION: ${STANDARD_IMAGE_VERSION}"
  (cd templates; ln -sf create_cluster_standard.tf.template create_cluster.tf.template)
fi

export KEYFILE=`jq -r '.keyfile' $config`
if [ -z $KEYFILE -o "$KEYFILE" == "null" ]; then
  abort "Your $config is not well-formed; it doesn't have the keyfile field"
else
  echo -e "\nKEYFILE: ${KEYFILE}\n"
fi
