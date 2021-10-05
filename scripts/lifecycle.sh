#!/usr/bin/env bash

cd `dirname $0`/..

let S0=`date +%s`

scripts/create_cluster.sh || exit $?

scripts/submit_job.sh || exit $?

scripts/delete_cluster.sh || exit $?

let S1=`date +%s`

let S=$S1-$S0

echo -e "\nTime taken: $S seconds\n"
