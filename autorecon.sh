#!/bin/bash

echo "             _______         ____        ____     ____________________       _____________    "
echo "            /       \        |   |       |   |    |                  |      |             |   "
echo "           /  ---    \       |   |       |   |    |                  |      |   -------   |   "
echo "          /   |  |    \      |   |       |   |    -------      ------       |   |     |   |   "
echo "         /    ---      \     |   ---------   |           |    |             |   |     |   |   "
echo "        /     ---       \    |               |           |    |             |   -------   |   "
echo "       /     /    \      \   |               |           |    |             |             |   "
echo "      /-----/      \------\  -----------------           ------             ---------------   "  


read -p "[?] Thanks you for using  autorecon please enter url of the website you want to scan: " url

if [ ! -d "$url" ]; then
      mkdir $url
fi

if [ ! -d "$url/recon" ]: then
      mkdir $url/recon
      touch $url/recon/all.txt
fi

echo "[+] Enumerating  subdomains with sublist3r ... "
sublist3r -d $url -o $url/recon/sublist3r.txt > /dev/null
cat $url/recon/sublist3r.txt >> $url/recon/all.txt

echo "[+] Enumerating subdomains with Amass ... "
amass enum -d $url >> $url/recon/amass.txt
cat $url/recon/amass.txt >> $url/recon/all.txt

echo "[+] Enumerating  subdomains with Assetfinder ... "
assetfinder --subs-only $url -o $url/recon/assetfinder.txt > /dev/null
cat $url/recon/assetfinder.txt >> $url/recon/all.txt

echo "[+] Enumerating  subdomains with subfinder ... "
subfinder -d $url -o $url/recon/subfinder.txt > /dev/null
cat $url/recon/subfinder.txt >> $url/recon/all.txt

echo "-------------------------------------------------"
echo "-------------------------------------------------"
echo "[+] Deleting duplications and sorting ..."

cat $url/recon/all.txt | sort | uniq > $url/recon/subs.txt

echo "[+] Probing for HTTP/HTTPS live websites ..."

cat $url/recon/subs.txt | httprobe >> $url/recon/live_websites.txt

echo "[+] Taking live screenshots with Gowitness ..."
gowitness file -f $url/reco/live_websites.txt > /dev/null
mv screenshots $url/recon/screenshots

