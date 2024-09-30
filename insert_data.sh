#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games,teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    if [[ -z $WINNER_ID ]]
    then
      WINNER_ID_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $WINNER_ID_RESULT == 'INSERT 0 1' ]]
      then
        WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
      fi
    fi

    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_ID_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $OPPONENT_ID_RESULT == 'INSERT 0 1' ]]
      then
        OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
      fi
    fi

    GAME_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $GAME_RESULT == 'INSERT 0 1' ]]
    then
      echo -e "\nINSERT $YEAR, $ROUND, $WINNER, $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS"
    fi
  fi
done