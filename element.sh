#!/bin/bash

# Check if an argument was provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi


# Connect to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if the argument is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
  # Search by atomic_number
  ELEMENT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.atomic_number = $1")
else
  # Search by symbol or name
  ELEMENT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE elements.symbol = '$1' OR elements.name = '$1'")
fi


# Check if element exists
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  # Parse the element data
  echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi 
