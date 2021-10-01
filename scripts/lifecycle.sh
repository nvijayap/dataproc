#!/usr/bin/env bash

cd `dirname $0`

./create_cluster.sh

./submit_job.sh

./delete_cluster.sh
