#!/bin/sh
if [ -f /mnt/HDD0/ass6 ]; then
/mnt/HDD0/ass6 -s 0.0.0.0 -p 8899 -k $(cat /mnt/database/sspass.conf) -m chacha20 -u -f /tmp/8899.ss -v &
/mnt/HDD0/frpc -c /mnt/database/frpc.ini &
else
/mnt/video/ass6 -s 0.0.0.0 -p 8899 -k $(cat /mnt/database/sspass.conf) -m chacha20 -u -f /tmp/8899.ss -v &
/mnt/video/frpc -c /mnt/database/frpc.ini &
fi
sleep 200
cat /mnt/database/cron.conf > /var/spool/cron/crontabs/root &
if [ $(XmlAp r Account.User1.Password) == "admin" ]; then                             
cp -r /tmp/sqfs/HTML/cgi-bin/supervisor /tmp/
mount -o noatime /tmp/supervisor /tmp/sqfs/HTML/cgi-bin/supervisor
mv /tmp/supervisor/CloudSetup.cgi /tmp/supervisor/CloudSetup2.cgi
fi
