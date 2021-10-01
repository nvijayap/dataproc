#!/usr/bin/env bash

# -------------
# functions.sh
# -------------

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
}
