#1/bin/bash
# Arguments are Date, Time, AM/PM, Game
if [[ $4 = *Bl* ]]; then
grep $2 $1_Dealer_schedule | grep $3 | awk '{print $1, $2, $3, $4}' 

 fi 

if [[ $4 = *Ro* ]]; then
grep $2 $1_Dealer_schedule | grep $3 | awk '{print $1, $2, $5, $6}' 

 fi 

if [[ $4 = *Te* ]]; then
grep $2 $1_Dealer_schedule | grep $3 | awk '{print $1, $2, $7, $8}' 

 fi 

