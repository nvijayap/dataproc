#!/usr/bin/env bash

# ---------------------------------------------------------
# create_jar.sh - creates the jar for submitting spark job
# ---------------------------------------------------------

# cat $0 # self-describe at runtime

cd `dirname $0`/..

source scripts/functions.sh

sbt clean package
