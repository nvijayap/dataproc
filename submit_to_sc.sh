#!/usr/bin/env bash

# -----------------------------------------------
# submit_to_sc.sh - submit to standalone cluster
# -----------------------------------------------

sbt clean package && \
spark-submit \
  --class com.example.Pi \
  --master spark://`hostname`:7077 \
  `find . -name \*.jar`
