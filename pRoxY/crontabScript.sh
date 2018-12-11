#!/bin/sh
source /etc/profile
PID=`ps aux | grep mitmweb | grep -v "grep" | wc -l`
while [[ $PID -eq 0 ]]; do
    cm="mitmweb --set web_port=8081 --set block_global=false -s /root/sourceCode/mitmproxy/mitmproxy-4.0.4-linux/matocloud_uuid.py"
    eval "$cm"
    echo `date` > /root/sourceCode/mitmproxy/mitmproxy-4.0.4-linux/xx.txt
    sleep 1
    exit 0
done

