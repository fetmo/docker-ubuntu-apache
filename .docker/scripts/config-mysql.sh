#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

USER="docker"
PASS="docker"

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Connection established?"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

mysql -uroot -e "CREATE USER '$USER'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%' WITH GRANT OPTION"
mysql -uroot -e "FLUSH PRIVILEGES"

echo "##################################################################"
echo "## MySQL User '$USER' with password '$PASS' successfully created  ##"
echo "##################################################################"

mysqladmin -uroot shutdown