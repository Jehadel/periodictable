#!/bin/bash

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.

else
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    GET_ATOM_NUM_RESULT=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1")
    
    if [[ ! -z $GET_ATOM_NUM_RESULT ]]
    then 
      echo "$GET_ATOM_NUM_RESULT" | while read NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi

    # if argument is a single letter
  elif [[ $1 =~ ^[A-Z]$ ]] || [[ $1 =~ ^[A-Z][a-Z]$ ]]
  then
    GET_SYMBOL_RESULT=$($PSQL "SELECT atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1'")
    
    if [[ ! -z $GET_SYMBOL_RESULT ]]
    then
      echo "$GET_SYMBOL_RESULT" | while read ATOMIC_NUMBER BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi

  # if argument is a word
  elif [[ $1 =~ ^[A-Za-z]+$ ]]
  then
    GET_NAME_RESULT=$($PSQL "SELECT atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name = '$1'")
    
    if [[ ! -z $GET_NAME_RESULT ]]
    then
      echo "$GET_NAME_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  
  fi

  if [[ -z $GET_NAME_RESULT ]] && [[ -z $GET_SYMBOL_RESULT ]] && [[ -z $GET_ATOM_NUM_RESULT ]]
    then
    echo "I could not find that element in the database."
  fi

fi
