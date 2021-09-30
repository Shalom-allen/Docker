#! /bin/bash
StartTime=`date +"%Y-%m-%d %H:%M:%S"`

for i in {1..1000} ;
do
        echo "set $i $i" >> result.txt
done

EndTime=`date +"%Y-%m-%d %H:%M:%S"`

echo "StartTime : ${StartTime}" >> time.log
echo "EndTime : ${EndTime}" >> time.log
