

if [[ -z $hive_script ]]; then
  select hive_script in `find . -type f -name "*.hive" | sed -e 's:.*\/::g' -e 's:\..*::g'`
  do
    if [[ -n $hive_script ]]; then
      break;
    fi
  done
fi

mkdir -p "data/$hive_script"
echo "getting data for $hive_script"
s3cmd sync "${HADOOP_OUTPUT_DIR}/$hive_script/" "data/$hive_script/"
