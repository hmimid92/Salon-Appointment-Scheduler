#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e '\n~~~~~ MY SALON ~~~~~\n'
echo -e 'Welcome to My Salon, how can I help you?'

MAIN_MENU()
    {
 if [[ $1 ]] 
  then 
   echo -e "\n$1"
  fi
 CUT_ID=$($PSQL "select service_id from services where name='cut'")
 COLOR_ID=$($PSQL "select service_id from services where name='color'")
 PERM_ID=$($PSQL "select service_id from services where name='perm'")
 STYLE_ID=$($PSQL "select service_id from services where name='style'")
 TRIM_ID=$($PSQL "select service_id from services where name='trim'")
 echo -e "\n$CUT_ID) cut\n$COLOR_ID) color\n$PERM_ID) perm\n$STYLE_ID) style\n$TRIM_ID) trim"
 read SERVICE_ID_SELECTED
 if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]] 
 then
 MAIN_MENU "Enter a valid number of service!"
 else 
 case $SERVICE_ID_SELECTED in
    1) SALON_SERVICE "$SERVICE_ID_SELECTED" "cut" ;;
    2) SALON_SERVICE "$SERVICE_ID_SELECTED" "color" ;;
    3) SALON_SERVICE "$SERVICE_ID_SELECTED" "perm" ;;
    4) SALON_SERVICE "$SERVICE_ID_SELECTED" "style" ;;
    5) SALON_SERVICE "$SERVICE_ID_SELECTED" "trim" ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
 fi
    }

SALON_SERVICE()
 {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_PHONE_NOTEXIST=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")
  if [[ ! $CUSTOMER_PHONE_NOTEXIST =~ $CUSTOMER_PHONE ]]
  then 
   echo -e "\nI don't have a record for that phone number, what's your name?"
   read CUSTOMER_NAME
   CUSTOMER_ADD=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
   echo -e "\nWhat time would you like your $2, $CUSTOMER_NAME?"
   read  SERVICE_TIME
   CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
   APPOINTMENT_ADD=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$1,'$SERVICE_TIME')")
   echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_NAME."
   else
  CUSTOMER_PHONE_EXIST=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
   echo -e "\nWhat time would you like your $2, $CUSTOMER_PHONE_EXIST?"
   read  SERVICE_TIME
   CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
   APPOINTMENT_ADD=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$1,'$SERVICE_TIME')")
   echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_PHONE_EXIST."
  fi
}
     
MAIN_MENU
