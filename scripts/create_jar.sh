#!/usr/bin/env bash

# ---------------------------------------------------------
# create_jar.sh - creates the jar for submitting spark job
# ---------------------------------------------------------

# cat $0 # self-describe at runtime

if [ ! -f ~/.dataproc/config.json ]; then
  echo "
  . Please create ~/.dataproc/config.json on these lines ...
{
  "project": "the-project-id",
  "region": "the-region",
  "zone": "the-zone",
  "keyfile": "~/.dataproc/the-key-file.json",
  "cluster": "dataproc-cluster-name",
}
  "
  exit 1
fi

type jq >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "\n . Please 'brew install jq' and then retry\n"
  exit 2
fi

type sbt >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "\n . Please 'brew install sbt' and then retry\n"
  exit 3
fi

cd `dirname $0`/..

sbt clean package
