#!/bin/bash

TIMESTAMP=$( date +%F-%H-%M-%S )
SCRIPTNAME=$( echo $0 | cut -d "." -f1 )
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2....$R FAILURE $N"
    else
       echo -e "$2....$G Success $N"
    fi
}
check_root(){
    USERID=$( id -u )
if [ $USERID -ne 0 ]
then
    echo "please run with root access"
    exit 1
else
    echo "your a root user"
fi
}