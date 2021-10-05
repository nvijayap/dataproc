#!/usr/bin/env bash

cd `dirname $0`/..

scripts/create_cluster.sh || exit $?

scripts/submit_job.sh || exit $?

scripts/delete_cluster.sh || exit $?
