#!/bin/bash
source ./common.sh


check_root

echo "please enter DB password"
read mysql_root_expense

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE "$?" "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE "$?" "Enabling nodejs:20 Version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE "$?" "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
   useradd expense &>>$LOGFILE
   VALIDATE "$?" "Creating expense user"
else
   echo -e "Expense user created... $Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE "$?" "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE "$?" "Downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE "$?" "Extracted backend code"

npm install &>>$LOGFILE
VALIDATE "$?" "Installing nodejs dependencies"

cp /home/ec2-user/expense-shell-1/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE "$?" "Copied backend.service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE "$?" "daemon-reload"

systemctl start backend &>>$LOGFILE
VALIDATE "$?" "Starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE "$?" "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE "$?" "Installing mysql client"

mysql -h db.rithinexpense.online -uroot -p${mysql_root_expense} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE "$?" "Schema loading"


systemctl restart backend &>>$LOGFILE
VALIDATE "$?" "Restarting backend"





