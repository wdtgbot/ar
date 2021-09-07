#!/bin/sh
export PATH=$PATH:/app/

echo "[xaria] Running Setup...."
./setup.sh &
pid=$!
wait $pid

echo "[xaria] Starting rpc...."
./aria2c --check-certificate=false --conf-path=/app/aria2.conf &
echo "[xaria] Starting Server...."
nginx
echo "[xaria] Servers are active...."
