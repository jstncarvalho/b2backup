#!/usr/bin/env bash
#
# Sync dirs to b2 bucket

id=__ID__
key=__KEY__
bucket=__BUCKET__
threads=__THREADS__

declare -A dir=(
    #["bucketSubfolder"]="/local/directory"
    ["backups"]="/backups" 
    ["www"]="/var/www"
)

logFile="/var/log/b2backup/$(date +%d)"

b2 authorize-account $id $key &> $logFile.log
for i in "${!dir[@]}"; do
    b2 sync --delete --threads $threads --noProgress "${dir["$i"]}" "b2://"$bucket/"$i" &> $logFile.log
done