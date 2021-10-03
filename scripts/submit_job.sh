#!/usr/bin/env bash

# ------------------------------------------------
# submit_job.sh - submits job to dataproc cluster
# ------------------------------------------------

cd `dirname $0`/..

source scripts/functions.sh

# creates jar if it doesn't exist already or is older than scala code
create_jar

echo -e "\n . Submitting spark job at `date` ...\n"

gcloud dataproc jobs submit spark --jar $JAR_PATH --cluster $CLUSTER
