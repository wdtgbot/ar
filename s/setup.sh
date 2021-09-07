#!/bin/sh

echo "[setup] Setup Script starting...."

# Config Port
echo "[setup] Configuring port $PORT...."
#sed -i "s|listen 80|listen ${PORT}|" nginx.conf
envsubst '\$PORT' < $(echo bmdpbng= | base64 -d).conf > /etc/nginx/$(echo bmdpbng= | base64 -d).conf

# Auth
echo "[setup] Configuring Authentication..."
echo "admin:$(openssl passwd -crypt admin)" > /app/.htpasswd
# If passwd is provided
if [ $HTPASSWD ]; then
    echo "admin:$(openssl passwd -crypt $HTPASSWD)" > /app/.htpasswd
else
    echo "admin:$(openssl passwd -crypt admin)" > /app/.htpasswd
fi

# Configure auth
if [ $SECRET ]; then
    echo "rpc-secret=${SECRET}" >> aria2.conf
else
    echo "rpc-secret=1234" >> aria2.conf
fi

# Configure Aria2
echo "[setup] Creating folder..."
mkdir -p downloads


#Configure Trackkers
echo "[setup] Downloading TrackerDB...."
wget -q https://github.com/wdtgbot/ku/raw/main/dht.dat
wget -q https://github.com/wdtgbot/ku/raw/main/dht6.dat
echo "[setup] Adding Trackers...."
tracker_list=$(curl -s https://trackerslist.com/all_aria2.txt)
echo "bt-tracker=$tracker_list" >> aria2.conf

# Configure Rclone
echo "[setup] Checking for Rclone Config...."
# .config/rclone/rclone.conf
if [[ ! -z ${RCLONE_CONFIG+x} && ! -z ${RCLONE_DESTINATION+x} ]]; then
	echo "[rclone] Rclone config detected"
	echo -e "$RCLONE_CONFIG" > rclone.conf
	echo "[aria2] Adding Rclone sync config...."
	echo "on-download-complete=/app/on-complete.sh" >> aria2.conf
	echo "on-download-stop=/app/on-stop.sh" >> aria2.conf
	chmod 755 on-complete.sh
	chmod 755 on-stop.sh
fi

export PATH=$PATH:$(cd)
echo $PATH > PATH

echo "[setup] Setup is now complete...."

# Python3 configs
#echo Installing python required....
#pip3 install wheel setuptools > /dev/null
#pip3 install youtube-dl > /dev/null
