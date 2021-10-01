#!/usr/bin/env bash

# ------------------------------------------------
# submit_job.sh - submits job to dataproc cluster
# ------------------------------------------------

cd `dirname $0`/..

source scripts/functions.sh

create_jar

CLUSTER=`jq -r .cluster ~/.dataproc/config.json`

JAR_PATH=`find . -name \*.jar`

echo -e "\n . Submitting spark job at `date` ...\n"

gcloud dataproc jobs submit spark --jar $JAR_PATH --cluster $CLUSTER
