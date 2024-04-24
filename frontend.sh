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

dnf install nginx -y  &>>$LOGFILE
VALIDATE "$?" "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE "$?" "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE "$?" "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE "$?" "Removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE "$?" "Downloading zip file"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE "$?" "Extracting file"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE "$?" "Copied expense.conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE "$?" "Restarting nginx"




