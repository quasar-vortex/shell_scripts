#!/bin/bash

out_dir="/opt/backups"
cur_date=$(date +'%Y-%m-%d_%H-%M')

mkdir -p "$out_dir/bkps"
if [ -s "$out_dir/$cur_date.sql.bz2" ]; then
	mv "$out_dir/$cur_date.sql.bz2" "$out_dir/bkps/$cur_date.sql.bz2.bkp"
fi

mysqldump portfolio > "$out_dir/$cur_date.sql"
bzip2 "$out_dir/$cur_date.sql
