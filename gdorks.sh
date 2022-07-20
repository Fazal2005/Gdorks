#!/bin/bash

rm -rf gdorks-tmp1.txt &> /dev/null
tar=$1
sfe=$(echo "$tar" | cut -d "." -f 1)
echo -n "+-www" > gdorks-tmp.txt

runtime="40 second"
endtime=$(date -ud "$runtime" +%s)

while [[ $(date -u +%s) -le $endtime ]]
do

for gdorks in $(cat gdorks-tmp.txt); do
g=$(curl "https://www.google.com/search?q=site:$tar$gdorks" -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)' -s | grep -Eoi '<a [^>]+>' |  grep -Eo 'href="[^\"]+"' |  grep -Eo '(http|https)://[^/"]+' | grep -i "$tar" | sort -u)

if echo "$g" | grep -i ".$tar" &> /dev/null;
  then
    echo "$g" | sed 's/https:\/\///g' | sed 's/http:\/\///g'
    echo "$g" | grep -v "https://$tar\|http://$tar" | cut -d '/' -f 3 | cut -d "." -f 1 | sed 's/\<$sfe\>//g' | sed 's/^/+-/' | sort -u | tr -d '\n' >> gdorks-tmp1.txt
else
        exit 1
fi
done < gdorks-tmp.txt

cat gdorks-tmp1.txt | tr '+-' '\n' | sort -u | sed 's/^/+-/' | tr -d '\n' > gdorks-tmp.txt
done