#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
SRVCSLCTNMSG="Hey there cutie! What can I do for you today?\n"
SERVICE_ID_SELECTED="0"
while [[ $SERVICE_ID_SELECTED != "1" && $SERVICE_ID_SELECTED != "2" && $SERVICE_ID_SELECTED != "3" ]]
do
  echo -e $SRVCSLCTNMSG
  SRVCSLCTNMSG="\nJust type one of the numbers to the left of the service you desire to request that service.\n"
  echo "$($PSQL "SELECT service_id, name FROM services")" | sed 's/|/) /'
  read SERVICE_ID_SELECTED
done
echo -e "\nIf you don't mind me saying, you look absolutely gorgeous. May I get your number?\n"
read CUSTOMER_PHONE
if [[ -z "$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")" ]]
then
  echo -e "\nOh! But where are my manners! My name is Fabio. What is yours?\n"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  echo -e "\nAnd when did you want to meet- I mean...schedule your appointment?"
else
  echo -e "\nWait, we've already met before? Ummm...okay, I'll wave the fee for this next appointment, just please don't tell anybody you know who I am.\nBut anyways, when did you want your appointment to be?\n"
fi
read SERVICE_TIME
CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")"
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
SERVICE_SELECTED="$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")"
CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")"
echo -e "\nI have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME.\n"