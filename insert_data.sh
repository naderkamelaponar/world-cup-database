#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL=" sudo -u postgres -H -- psql -d worldcup -t --no-align -c" 
  echo $PSQL
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
# year,round,winner,opponent,winner_goals,opponent_goals
clear
echo -e "\nCleaning the database"
echo "$($PSQL "truncate table games, teams;")"
cat test_games.csv | while IFS="," read YEAR  ROUND  WINNER   OPPONENT  WINNER_GOALS  OPPONENT_GOALS
do 

  echo $YEAR $ROUND $WINNER $OPPONENT   
  if [[ $YEAR != year ]]
  then
    # get winner id
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    # if not found 
    if [[ -z $WINNER_ID ]]
    then 
      INSERT_WINNER=$($PSQL "insert into teams (name) values('$WINNER') ")
      
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo $WINNER inserted into teams .
      fi
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'") 
    fi
    #### end of winner id
    # get opponent id
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
     # if not found 
    if [[ -z $OPPONENT_ID ]]
    then 
      INSERT_OPPONENT=$($PSQL "insert into teams (name) values('$OPPONENT') ")
      
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then
        echo $OPPONENT inserted into teams .
      fi
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'") 
    fi
    #### end of opponent id
    # insert into games table
    INSERT_GAMES=$($PSQL "insert into games (year,round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND' , $WINNER_ID, $OPPONENT_ID , $WINNER_GOALS, $OPPONENT_GOALS )    ")
    if [[ $INSERT_GAMES == "INSERT 0 1" ]]
    then
      echo Inserted $ROUND,$WINNER,$OPPONENT into games table
    fi
  fi
  

done
