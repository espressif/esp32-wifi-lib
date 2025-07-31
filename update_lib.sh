#!/bin/bash
if [ $1 != "update" -a $1 != "rebase" ]; then
   echo $0 update commit_id [path]
   echo $0 rebase commit_id [path]
   exit 1
fi

cmd=$1
if [ -z $2 ]; then
   echo wrong commit_id $2
   exit 1
fi
SHA=$2

LIB_PATH=$3
if [ -z $3 ]; then
   LIB_PATH=/mnt/software_output23/esp32_rtos_sdk_core
fi

result=$(find $LIB_PATH -name *$SHA -print -quit | head -n 1)
echo find $SHA in $result
suffix="${result##*/}"
IFS="^" read -r sbranch tbranch mr_number commit_id <<< "$suffix"
sbranch="${sbranch//\~/\/}"
if [ $tbranch == "ng_net80211" ]; then
    tbranch=master
fi
if [ $commit_id != $SHA ];then
    echo commit id $commit_id does not match $SHA
    exit 1
fi
echo source branch is $sbranch
echo target branch is $tbranch 
echo VNC MR number $mr_number
echo VNC commit SHA is $commit_id

if [ $cmd == "rebase" ]; then
    cd ..
    echo change to esp-idf dir $(pwd)
    git pull
    git checkout $tbranch
    git pull origin $tbranch
    git checkout $sbranch
    cd lib
    echo change to wifi-lib dir $(pwd)
fi

echo checkout $tbranch
git checkout $tbranch
echo pull origin $tbranch
git pull origin $tbranch
echo delete branch $sbranch
git branch -D $sbranch
echo checkout $sbranch on $tbranch
git checkout -b $sbranch
echo cp $result to local
cp $result/* . -rf
./fix_printf.sh
commit_message=$(cat $result/MR_TITLE | head -n 1)
commit_message=$commit_message" VNC MR"$mr_number" ("$commit_id")"
echo $commit_message
git commit -am "$commit_message"
rm MR_TITLE


if [ $cmd == "rebase" ]; then
    cd ..
    echo change to esp-idf dir $(pwd)
    git commit -a --amend
    git rebase $sbranch
    cd lib
    echo change to wifi-lib dir $(pwd)
fi

echo please notice that $sbranch for wifi-lib and esp-idf not pushed to gitlab, please do the push manully.
