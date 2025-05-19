#!/bin/bash

db_name="portfolio"
out_dir="/opt/backups"
cur_date=$(date +'%Y-%m-%d_%H-%M')
sql_file="$cur_date.sql"
compressed="$sql_file.bz2"
bkp_dir="$out_dir/bkps"

function handle_existing_items() {
	mkdir -p "$bkp_dir"
	if [ -s  "$compessed" ]; then
		echo "Moving $compressed to $bkp_dir/$compressed.bkp"
		mv "$compressed" "$bkp_dir/$compressed.bkp"
	fi
}

function dump_file() {
	echo "Dumping and Compressing"
	if ! mysqldump "$db_name" > "$sql_file"; then
 		echo "Dump failed"
   		rm -rf "$sql_file"
     		exit 1
       fi
	bzip2 "$sql_file"
}

handle_existing_items
dump_file
