#!/usr/bin/env bash

cd `dirname $0`/..

scripts/create_cluster.sh

scripts/submit_job.sh

scripts/delete_cluster.sh
