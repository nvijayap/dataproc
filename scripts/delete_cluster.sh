#!/usr/bin/env bash

# ------------------
# delete_cluster.sh
# ------------------

cd `dirname $0`/..

trap "/bin/rm -fr tf" SIGINT SIGTERM EXIT

source scripts/functions.sh

KEYFILE=`jq -r .keyfile ~/.dataproc/config.json`
CLUSTER=`jq -r .cluster ~/.dataproc/config.json`

PROJECT=`jq -r .project ~/.dataproc/config.json`
REGION=`jq -r .region ~/.dataproc/config.json`
ZONE=`jq -r .zone ~/.dataproc/config.json`

rm -fr tf; mkdir tf

sed "
s|KEYFILE|$KEYFILE|g
s|CLUSTER|$CLUSTER|g
s|PROJECT|$PROJECT|g
s|REGION|$REGION|g
s|ZONE|$ZONE|g
" templates/delete_cluster.tf.template >tf/delete_cluster.tf

echo -e "\n . Validating ...\n"

terraform validate || exit 1

echo -e "\n . Destroying ...\n"

terraform destroy -auto-approve || exit 3

echo -e "\n . Done deleting cluster\n"
