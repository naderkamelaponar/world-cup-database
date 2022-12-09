#! /bin/bash

# PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"
if [[ $1 == "test" ]]
then
  PSQL=" sudo -u postgres -H -- psql -d worldcup -t --no-align --tuples-only -c" 
  echo $PSQL
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align --tuples-only -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
clear
echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"
# 90
echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT sum(winner_goals + opponent_goals) from games")"
# 2.1250000000000000
echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "select avg(winner_goals) from games")"
# 2.13
echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "select ROUND(avg(winner_goals) , 2) from games")"
# 2.8125000000000000
echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT avg(winner_goals + opponent_goals) from games")"
# 7
echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "select max(winner_goals) from games ")"
# 6
echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "select count(*) from games where winner_goals > 2")"
# France
echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "select name from teams join games on teams.team_id = games.winner_id where round='Final' and year=2018" )"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "select name  from teams join games on teams.team_id = opponent_id or  teams.team_id = games.winner_id  where year=2014 and round='Eighth-Final' group by teams.name order by teams.name;" )"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "select name from teams join games on teams.team_id = games.winner_id group by name order by name;")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "select  year,name from games right join teams on games.winner_id = teams.team_id where round='Final' order by year;")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "select name from teams where name like 'Co%';")"
