#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU() {

   if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
   #show menu
    SERVICES_AVAILABLE=$($PSQL "SELECT service_id, name FROM services")
  
  #read response
  echo "$SERVICES_AVAILABLE" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
    
  SERVICE_EXISTS=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  
  #if not a number
  if [[ -z $SERVICE_EXISTS ]]
  then 
  
  MAIN_MENU "I could not find that service. What would you like today?"
  else




  SET_APPOINTMENT
  fi
}

SET_APPOINTMENT() {
 #get services

   #get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'") 

  #get info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #if phone number is new
  if [[ -z $CUSTOMER_NAME ]]
 #get their info
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
  
  #insert info to database
  
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

  fi

    TIME_FORMATTED=$(echo $SERVICE_NAME, $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
    #get service time
    echo -e "\nWhat time would you like your $TIME_FORMATTED?"
    read SERVICE_TIME

  #get id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #put appointment in database
    MAKE_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', '$SERVICE_ID_SELECTED', $CUSTOMER_ID)")
  
#  RESPONSE_INFO=$($PSQL "SELECT name")
  RESPONSE_FORMATTED=$(echo $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME | sed -r 's/^ *| *$//g')

   echo -e "\nI have put you down for a $RESPONSE_FORMATTED."

}

EXIT() {
  echo -e "\nThank you for stopping in.\n"

}

MAIN_MENU

#display a numbered list of services offered like the bike one
#if a number that doesn't exist is added, show list again

#read below into SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, SERVICE_TIME

#promt user to enter service_id, phone, name

#if not already customer, get phone and name first

#user should enter time

#a row in appointments is created by entering "1, 555-555-5555, Fabio, 10:30" customer_id and service_id should be input automatically

