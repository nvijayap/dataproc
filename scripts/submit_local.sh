#!/usr/bin/env bash

# --------------------------------------------------------------------------
# submit_local.sh - submit job to local standalone spark cluster
# --------------------------------------------------------------------------

cd `dirname $0`/..

type nc >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "\n . Please 'brew install nc' and then retry\n"
  exit 1
fi

find . -name \*.jar >/dev/null 2>&1

if [ $? -eq 0 ]; then
  JAR_FILE=`find . -name \*.jar`
  SRC_FILE=`find . -name \*.scala`
  if [ $SRC_FILE -nt $JAR_FILE ]; then
    echo -e "\n . $SRC_FILE is newer than $JAR_FILE\n"
    scripts/create_jar.sh
  fi
else
  echo -e "\n . Jar file not found\n"
  scripts/create_jar.sh
fi

nc -zv `hostname` 7077 >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "\n . Please bring up local spark standalone cluster and then retry\n"
  exit 2
fi

spark-submit \
  --class com.example.Pi \
  --master spark://`hostname`:7077 \
  `find . -name \*.jar`
