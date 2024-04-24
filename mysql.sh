#!/bin/bash

TIMESTAMP=$( date +%F-%H-%M-%S )
SCRIPTNAME=$( echo $0 | cut -d "." -f1 )
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "please enter DB password"
read mysql_root_expense

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2....$R FAILURE $N"
    else
       echo -e "$2....$G Success $N"
    fi
}
USERID=$( id -u )
if [ $USERID -ne 0 ]
then
    echo "please run with root access"
    exit 1
else
    echo "your a root user"
fi
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


