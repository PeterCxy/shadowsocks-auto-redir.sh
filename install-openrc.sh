#!/bin/bash
link() {
    ln -sf $PWD /opt/shadowsocks-auto-redir
    cp $PWD/openrc/shadowsocks-auto-redir /etc/init.d/
    ln -s /etc/init.d/shadowsocks-auto-redir /etc/init.d/shadowsocks-auto-redir.v4
    ln -s /etc/init.d/shadowsocks-auto-redir /etc/init.d/shadowsocks-auto-redir.v6
}

config() {
    cp /etc/shadowsocks-libev/redir.json /etc/shadowsocks-libev/redir.v4.json
    sed -e "s/127.0.0.1/::1/" /etc/shadowsocks-libev/redir.json | sed -e "s/1081/1082/" > /etc/shadowsocks-libev/redir.v6.json
}

unlink() {
    rm -rf /opt/shadowsocks-auto-redir
    rm -rf /etc/init.d/shadowsocks-auto-redir*
}

update() {
    rm -rf /etc/init.d/shadowsocks-auto-redir
    cp $PWD/openrc/shadowsocks-auto-redir /etc/init.d/
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
elif [[ "$1" == "config" ]]; then
    config
fi
