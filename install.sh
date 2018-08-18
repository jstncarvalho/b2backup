#!/usr/bin/env bash

if ((BASH_VERSINFO[0] < 4))
then 
  echo "Bash version >= 4 required" 
  exit 1 
fi
while getopts i:k:b:t: option; do
    case "${option}" in
        i) id=${OPTARG};;
        k) key=${OPTARG};;
        b) bucket=${OPTARG};;
        t) threads=${OPTARG};;
        *) exit 1;;
    esac
done

echo $id;
exit 1;

rm -rf temp && mkdir temp

cp ./b2backup.sh temp/b2backup
pushd temp
sed -i -e "s/\__ID__/$id/" b2backup
sed -i -e "s/__KEY__/$key/" b2backup
sed -i -e "s/__BUCKET__/$bucket/" b2backup
sed -i -e "s/__THREADS__/$threads/" b2backup
chmod +x b2backup
mv ./b2backup /usr/local/bin/.

git clone https://github.com/Backblaze/B2_Command_Line_Tool.git
pushd B2_Command_Line_Tool
python setup.py install
popd

popd

croncmd="/usr/local/bin/b2backup"
cronjob="0 4 * * * $croncmd"
( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -

rm -rf temp

echo "Installed at /usr/local/bin/. Cronjob daily at 4am."