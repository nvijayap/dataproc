#!/usr/bin/env bash

# ---------------------------------------------------------------
# create_cluster.sh - creates a dataproc cluster using terraform
# ---------------------------------------------------------------

cd `dirname $0`/..

source scripts/functions.sh || exit $?

# creates jar if it doesn't exist already or is older than scala code
create_jar

gcloud dataproc clusters list | grep -q $CLUSTER

if [ $? -eq 0 ]; then
  echo -e "\n$CLUSTER already exists\n"
  exit 1
fi

mkdir -p tf

sed "
s|KEYFILE|$KEYFILE|g
s|CLUSTER|$CLUSTER|g
s|STANDARD_IMAGE_VERSION|$STANDARD_IMAGE_VERSION|g
s|CUSTOM_IMAGE_URL|$CUSTOM_IMAGE_URL|g
s|PROJECT|$PROJECT|g
s|REGION|$REGION|g
s|ZONE|$ZONE|g
s|JAR_PATH|$JAR_PATH|g
s|JAR_NAME|$JAR_NAME|g
" templates/create_cluster.tf.template >tf/main.tf

cd tf

echo -e "\n . Initing terraform ...\n"

terraform init || exit 1

echo -e "\n . Validating terraform configuration ...\n"

terraform validate || exit 1

for gs in `gsutil ls`; do gsutil rm -r $gs; done

echo -e "\n . Creating dataproc cluster at `date` ...\n"

terraform apply -auto-approve || exit 2

echo -e "\n . Done creating dataproc cluster at `date`\n"
