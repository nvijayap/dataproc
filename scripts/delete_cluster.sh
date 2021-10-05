#!/usr/bin/env bash

# ------------------
# delete_cluster.sh
# ------------------

cd `dirname $0`/..

source scripts/functions.sh || exit $?

echo -e "\n . Deleting dataproc cluster at `date` ...\n"

gcloud -q dataproc clusters delete --region=$REGION $CLUSTER
