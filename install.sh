#!/bin/bash
link() {
    ln -sf $PWD /opt/shadowsocks-auto-redir
    cp $PWD/systemd/shadowsocks-auto-redir@.service /etc/systemd/system/shadowsocks-auto-redir@.service
    systemctl daemon-reload
}

unlink() {
    rm -rf /opt/shadowsocks-auto-redir
    rm -rf /etc/systemd/system/shadowsocks-auto-redir@.service
    systemctl daemon-reload
}

update() {
    curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | \
     awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > \
     routes/chnroute.txt
    rm -rf /etc/systemd/system/shadowsocks-auto-redir@.service
    cp $PWD/systemd/shadowsocks-auto-redir@.service /etc/systemd/system/shadowsocks-auto-redir@.service
    systemctl daemon-reload
}

# MUST be run as root
if [ `id -u` != "0" ]; then
    echo "This script MUST BE run as ROOT"
    exit 1
fi

if [[ "$1" == "link" ]]; then
    link
elif [[ "$1" == "unlink" ]]; then
    unlink
elif [[ "$1" == "update" ]]; then
    update
fi
