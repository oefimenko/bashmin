#!/bin/bash

	DATE="20/Jun/2018:"
	TIME_HOUR="10:"



RED='\033[0;31m'
YEL='\033[1;33m'
NC='\033[0m' # No Color
COLOR=$RED

#echo -e "${RED}$DATE$TIME_HOUR$TIME_MIN ${NC}"| tr -d '\n'



for TIME_MIN in {01..60}
do 
echo -e "${COLOR}$DATE$TIME_HOUR$TIME_MIN ${NC}"| tr -d '\n'
echo -e "${YEL} # req_count ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep -c $DATE$TIME_HOUR$TIME_MIN | tr -d '\n'

echo -e "${YEL} # count_uniq_ip ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep $DATE$TIME_HOUR$TIME_MIN | awk '{print $2}' | sort | uniq -c | wc -l | tr -d '\n'

echo -e "${YEL} # count 20x ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep $DATE$TIME_HOUR$TIME_MIN | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 20 | tr -d '\n'

echo -e "${YEL} # count 50x ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep $DATE$TIME_HOUR$TIME_MIN  | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 50 | tr -d '\n'

echo -e "${YEL} # count 40x ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep $DATE$TIME_HOUR$TIME_MIN  | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 40 | tr -d '\n'

echo -e "${YEL} # count 499 ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep $DATE$TIME_HOUR$TIME_MIN  | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 49 | tr -d '\n'

echo -e "${YEL} # count 30x ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep $DATE$TIME_HOUR$TIME_MIN  | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |grep -c 30 | tr -d '\n'

echo -e "${YEL} # count other ${NC}" | tr -d '\n'
cat /var/log/nginx/ticket.rzd.ru_access.log | grep $DATE$TIME_HOUR$TIME_MIN  | awk -F "\"" '{print $3}' | awk -F" "  '{print $1}' |egrep -vc "30|49|40|50|20" | tr -d '\n'




echo
done
