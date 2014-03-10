#! /bin/bash

job=$1

case "$job" in
  last) job=`emr --list --state COMPLETED 2>/dev/null| head -1 | sed -e 's: .*::g'`;;
esac

s3cmd get -r "${HADOOP_LOG_DIR}/$job" logs

open logs/$job
