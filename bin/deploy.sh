#! /bin/bash


if [[ -z $hive_script ]]; then
  select hive_script in `find . -type f -name "*.hive" | sed -e 's:.*\/::g'`
  do
    if [[ -n $hive_script ]]; then
      break;
    fi
  done
fi
      
fp=`find . -type f -name "$hive_script"`

s3cmd put $fp "${HIVE_SCRIPT_DIR}"

