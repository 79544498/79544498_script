#!/bin/bash

set -e

apt update
apt install -y ssh vim curl zip

cat >/etc/sysctl.d/fq.conf <<EOF
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

sysctl --system

bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root

wget -O /root/config.bin https://raw.githubusercontent.com/79544498/79544498_script/main/config.bin

openssl enc -d -aes-256-cbc -in /root/config.bin -out /usr/local/etc/xray/config.json

systemctl enable xray
systemctl restart xray

rm /root/config.bin
