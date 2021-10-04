#!/usr/bin/env bash

# -------------
# functions.sh
# -------------

cd `dirname $0`/..

source scripts/prereqs.sh

create_jar() {
  if [ `find . -name \*.jar | wc -l` -eq 1 ]; then
    JAR_FILE=`find . -name \*.jar`
    echo "JAR_FILE: $JAR_FILE"
    SRC_FILE=`find . -name \*.scala`
    echo "SRC_FILE: $SRC_FILE"
    if [ $SRC_FILE -nt $JAR_FILE ]; then
      echo -e "\n . Source file is newer than jar file so recreating jar file\n"
      scripts/create_jar.sh
    fi
  else
    echo -e "\n . Jar file not found so creating it\n"
    scripts/create_jar.sh
  fi
  JAR_PATH=`find . -name \*.jar`
  JAR_NAME=`basename $JAR_PATH`
}
