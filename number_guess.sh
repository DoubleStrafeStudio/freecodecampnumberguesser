#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"



USER_LOGIN(){
  # Display a message if needed.
  if [[ $1 ]]
  then
    echo $1
  fi

  # Have user input their username
  echo Enter your username:
  read USERNAME

  ## Check if username is over 22 characters long
  USERNAME_LENGTH=${#USERNAME}
  # echo -e "Your user name is $USERNAME_LENGTH characters long."
  while (( USERNAME_LENGTH > 22 ))
  do
    echo "Please enter a username with a maximum of 22 characters."
    read USERNAME
    USERNAME_LENGTH=${#USERNAME}
  done

  # Query the table of existing users to see if user already exists
  USERNAME_RESPONSE=$($PSQL "SELECT * FROM users WHERE username='$USERNAME'")
  # Test if user does not exist
  if [[ -z $USERNAME_RESPONSE ]]
    # If the user does not exist
    then
      echo -e "Welcome, $USERNAME! It looks like this is your first time here."
      # add the user to the database.
      ADD_USER_RESPONSE=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
    # If the user exists
    else
      # get their user information (user id, username, games played, and best game)
      # echo $USERNAME_RESPONSE | while IFS="|" read USER_ID USERNAME GAMES_PLAYED BEST_GAME
      GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME'")
      BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
      # do
        echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
      # done
  fi
  
  # echo -e "I say again, you have played $GAMES_PLAYED games."
  # echo -e "Your username is $USERNAME"

  # Start a game

  # Generate a number between 1 and 1000  
  NUMBER=$(($RANDOM%(1000)+1))
  # NUMBER=$(shuf -i 1-1000 -n 1)
  echo -e "Don't tell the user, but the secret number is $NUMBER."

  # Get user's guess
  echo Guess the secret number between 1 and 1000:
  read GUESS
  # If the guess is not a number, keep asking for a guess until user provides a number.
  while ! [[ $GUESS =~ ^[0-9]+$ ]];
  do 
    echo That is not an integer, guess again:
    read GUESS
  done

  # Create a counter for the number of guesses taken.
  NUMBER_OF_GUESSES=1

  # Set a while loop that continues to request a number until the guess matches the number.
  while [ $GUESS != $NUMBER ];
  do

    # provide a hint, depending on the guess:
    if [[ $GUESS -gt $NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    elif [[ $GUESS -lt $NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    fi

    read GUESS
    while ! [[ $GUESS =~ ^[0-9]+$ ]];
    do 
      echo That is not an integer, guess again:
      read GUESS
    done

    # Increment the number of guesses after each loop.
    let NUMBER_OF_GUESSES++
  done


  # Update the user's number of games played
  NEW_GAMES_PLAYED=$GAMES_PLAYED+1
  UPDATE_GAMES_PLAYED_RESPONSE=$($PSQL "UPDATE users SET games_played = $NEW_GAMES_PLAYED WHERE username = '$USERNAME'")

  # If applicable, update the best game
  if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ||  -z $BEST_GAME ]]
  then
    UPDATE_BEST_GAME_RESPONSE=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES WHERE username= '$USERNAME'")
  fi
  # USER_ID_RESPONSE=$($PSQL "SELECT * FROM users WHERE user_id = $USER_ID")
  # echo $USER_ID_RESPONSE | while IFS="|" read USER_ID USERNAME GAMES_PLAYED BEST_GAME
  # do
  #   echo $USER_ID_RESPONSE
  # done
  # echo -e "To recap, you previously played $GAMES_PLAYED games."
  # NEW_GAMES_PLAYED=$GAMES_PLAYED+1
  # echo $NEW_GAMES_PLAYED
  # USER_ID=$1
    # UPDATE_USER_RESULT=$($PSQL "UPDATE users SET games_played = $NEW_GAMES_PLAYED WHERE user_id = 1")
  # if [[ $3 -gt $NUMBER_OF_GUESSES | -z $3 ]]
  # then
  #   UPDATE_USER_RESULT=$($PSQL "UPDATE users SET best_game = $NUMBER_OF_GUESSES, games_played = $NEW_GAMES_PLAYED WHERE user_id = $1")
  # else
  # fi

  echo -e "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!"
}



# GUESS_GAME() {
 
# }
USER_LOGIN

# GUESS_GAME
