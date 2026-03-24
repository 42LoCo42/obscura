#!/usr/bin/env bash

cache="${CACHE_DATA_PATH:-}"

args=("$@")
while (($#)); do
	case "$1" in
	--cache-data-path)
		shift
		cache="$1"
		;;
	esac
	shift
done

if [ -z "$cache" ]; then
	echo "[1;31mERROR:[m no cache path specified!"
	exit 1
fi

db="$cache/db.sqlite"
mkdir -p "$(dirname "$db")"
dbmate --url "sqlite:$db" --migrations-dir "@mgr@" up

exec "@bin@" "${args[@]}" --cache-database-url "sqlite:$db"
