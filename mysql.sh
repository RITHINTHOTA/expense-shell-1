#!/bin/bash
source ./common.sh

check_root

echo "please enter DB password"
read mysql_root_expense

dnf install mysql-server -y &>> $LOGFILE
VALIDATE "$?" "Installing mysql server"

systemctl enable mysqld &>> $LOGFILE
VALIDATE "$?" "Enabling mysql server"

systemctl start mysqld &>> $LOGFILE
VALIDATE "$?" "starting mysql server"

mysql -h db.rithinexpense.online -uroot -p${mysql_root_expense} -e 'show databases;' &>> $LOGFILE
if [ $? -ne 0 ]
then
   mysql_secure_installation --set-root-pass ${mysql_root_expense}
   VALIDATE "$?" "setting up root password"
else
 echo -e "Mysql root password is already setup...$Y SKIPPING $N"
fi


