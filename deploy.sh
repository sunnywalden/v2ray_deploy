#! /bin/bash

# install docker
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
systemctl enable docker
systemctl start docker

# allow long ssh connect
sed -i 's/#ClientAliveInterval/ClientAliveInterval/g' /etc/ssh/sshd_config
sed -i 's/#CClientAliveCountMax/ClientAliveCountMax/g' /etc/ssh/sshd_config
systemctl restart sshd

# get image
docker pull sunnywalden/v2r:latest

# vpn deploy
mkdir -p /etc/v2ray/

cat > /etc/v2ray/config.json << EOF
{
    "inbounds": [
        {
            "port": 25889, // 服务器监听端口
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "b831381d-6324-4d53-ad4f-8cda48b30811"
                    }
                ]
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF


docker run -d --name v2r -v /etc/v2ray:/etc/v2ray -p 25889:25889 sunnywalden/v2r v2ray -config=/etc/v2ray/config.json


wget "https://github.com/cx9208/bbrplus/raw/master/ok_bbrplus_centos.sh" && chmod +x ok_bbrplus_centos.sh && ./ok_bbrplus_centos.sh


# 重启后操作
docker start v2r
uname -r

lsmod | grep bbrplus

yum -y install ntp ntpdate
# ntpdate uk.pool.ntp.org
# hwclock --systohc
date
