#!/bin/bash

DATE="20/Jun/2018:"
TIME_HOUR="10:"

RED='\033[0;31m'
YEL='\033[1;33m'
NC='\033[0m' # No Color
COLOR=$RED

#echo -e "${RED}$DATE$TIME_HOUR$TIME_MIN ${NC}"| tr -d '\n'

#TMP_MIN_LOG=`mktemp -p /home/oleg/tmp`
#echo $TMP_MIN_LOG
#cat /var/log/nginx/ticket.rzd.ru_access.log |  grep $DATE$TIME_HOUR$TIME_MIN > $TMP_MIN_LOG



for TIME_MIN in {01..60}
do 
	TMP_MIN_LOG=`mktemp -p /home/oleg/tmp`
	echo $TMP_MIN_LOG
	cat /var/log/nginx/ticket.rzd.ru_access.log |  grep $DATE$TIME_HOUR$TIME_MIN > $TMP_MIN_LOG

	echo -e "${COLOR}$DATE$TIME_HOUR$TIME_MIN - top ten of slow GET request ${NC}" 

	TMP_FILE=`mktemp -p /home/oleg/tmp`

 	#make:  60.002     81.163.249.95 "GET /apib2b//station/search?name=%D0%B1%D1%80%D1%8F&lang=ru
	cat $TMP_MIN_LOG |  grep GET | awk '{print $1"     "$2" "$7" " $8}' | sort -n | tail > $TMP_FILE

	cat $TMP_FILE
		for IP in $(cat $TMP_FILE | awk {'print $2'})
		   do
			echo -e "${COLOR} $IP ${NC}"| tr -d '\n'
			echo -e "${YEL} # req_count  ${NC}" | tr -d '\n'
			cat $TMP_MIN_LOG | grep $IP | wc -l | tr -d '\n'

			echo -e "${YEL} # count 20x ${NC}" | tr -d '\n'
			cat $TMP_MIN_LOG | grep $IP | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 20 | tr -d '\nN'

			echo -e "${YEL} # count 50x ${NC}" | tr -d '\n'
			cat $TMP_MIN_LOG | grep $IP | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 50 | tr -d '\n'

			echo -e "${YEL} # count 40x ${NC}" | tr -d '\n'
			cat $TMP_MIN_LOG  | grep $IP | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 40 | tr -d '\n'

			echo -e "${YEL} # count other ${NC}" | tr -d '\n'
			cat $TMP_MIN_LOG  | grep $IP | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |egrep -vc "40|50|20" | tr -d '\n'

			echo			
     		   done

rm -rf $TMP_FILE
rm -rf $TMP_MIN_LOG

echo
done
