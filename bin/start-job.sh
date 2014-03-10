#! /bin/bash

while getopts y:m:d:h:i:s:t: o
do
  case "$o" in
  y) year="$OPTARG";;
  m) month="$OPTARG";;
  d) day="$OPTARG";;
  h) hour="$OPTARG";;
  i) instances="$OPTARG";;
  s) hive_script="$OPTARG";;
  t) instance_type="$OPTARG";;
  [?]) print >&2 "Usage: $0 [-y year] [-m month] [-d day] [-h hour] [-i num instances] [-s hive_script]"
       exit 1;;
  esac
done
#shift $OPTIND-1

if [[ -z $hive_script ]]; then
  select hive_script in `find . -type f -name "*.hive" | sed -e 's:.*\/::g'`
  do
    if [[ -n $hive_script ]]; then
      break;
    fi
  done
fi

if [[ -z $instance_type ]]; then
  select instance_type in {'m1.medium','c1.medium','m1.large','m2.xlarge','m1.xlarge','c1.xlarge'}
  do
    if [[ -n $instance_type ]]; then
      echo $instance_type
      break;
    fi
  done
fi

elastic-mapreduce                                      \
--create                                               \
--name "$hive_script $year$month$day$hour"             \
--instance-type $instance_type                         \
--num-instances $instances                             \
--hive-script                                          \
--arg s3://${HIVE_SCRIPT_DIR}/$hive_script             \
--args -d,YEAR=$year                                   \
--args -d,MONTH=$month                                 \
--args -d,DAY=$day                                     \
--args -d,HOUR=$hour                                      
