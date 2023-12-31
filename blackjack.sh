#!/usr/bin/env bash

# Set some text colours
greentext="\033[32m"
bold="\033[1m"
normal="\033[0m"
ulinered="\033[4;31;40m"
red="\033[31;40m"

# Blackjack score test
scoretest(){
    # Make them wait
    sleep 2
    # If the score is 21 (blackjack)
    if [[ $1 -eq 21 ]]; then
        echo -e "$greentext $bold Blackjack! $normal"
        keepplaying=1
        win=0
        
        # If the score is > 21 (bust)
        elif [[ $1 -gt 21 ]]; then
        echo -e "$ulinered Bust! $normal"
        keepplaying=1
        win=1
        
        # If the score is less than 18, keep playing
        elif [[ $1 -lt 18 ]]; then
        echo -e "Current score: $1\nContinue playing."
        keepplaying=0
        win=1
        
        # If the score is < 21 but >= 18, call it quits
    else
        echo -e "Current score: $1\nCall it quits!"
        keepplaying=1
        win=1
    fi
}


## Games
# Blackjack
blackjack(){
    # Echo the name of the game and your wager
    echo -e "\nWelcome to the Blackjack table!"
    printf "You have wagered \$%i on this game.\n" $1
    
    # Set lists of the suits and cards
    suit=( Clubs Diamonds Spades Hearts )
    card=( 2 3 4 5 6 7 8 9 10 Jack Queen King Ace )
    
    # Set the values of the cards
    declare -A values
    values[2]=2;    values[3]=3;    values[4]=4;    values[5]=5;    values[6]=6
    values[7]=7;    values[8]=8;    values[9]=9;    values[10]=10;   values[Jack]=10
    values[Queen]=10;               values[King]=10;                values[Ace]=11
    
    # Set initial score to 0, setting the score variable as an integer
    declare -i score=0
    # Set number of cards in hand
    declare -i cardsinhand=0
    
    # Print the progress of the game
    echo "Dealing..."
    # Make them wait
    sleep 2
    # Get the suits of the two cards that were dealt
    for i in 1 2
    do
        # Random Suit
        local -i rand_suit=$[$RANDOM % ${#suit[@]}]
        # Random Card - give a number for the index in the list of card names, NOT the card name
        local -i rand_card=$[$RANDOM % ${#card[@]}]
        # Print to user the card they were dealt
        echo "Card: ${card[$rand_card]} of ${suit[$rand_suit]}"
        # Calculate score, add one more card to hand
        ((score=$score+${values[${card[$rand_card]}]}))
        ((cardsinhand++))
    done
    
    # Print progress of game
    echo "Dealt. Calculating score of dealt hand..."
    
    # Score test
    scoretest $score
    
    # If they need to draw another card...
    if [[ $win -eq 1 && $keepplaying -eq 0 ]];
    then
        # While they need to keep drawing cards...
        while [[ $win -eq 1 && $keepplaying -eq 0 ]];
        do
            # Tell the user we're drawing another card
            echo "Drawing another card..."
            # Make them wait
            sleep 2
            # Add another card to hand
            (( cardsinhand++ ))
            # Random Suit
            local -i rand_suit=$[$RANDOM % ${#suit[@]}]
            # Random Card - give a number for the index in the list of card names, NOT the card name
            local -i rand_card=$[$RANDOM % ${#card[@]}]
            # Print to user the card they were dealt
            echo "Card: ${card[$rand_card]} of ${suit[$rand_suit]}"
            ((score=$score+${values[${card[$rand_card]}]}))
            # do score test
            scoretest $score
        done
    fi
    
    # End the game
    # If they got blackjack, they win some more money. 4 times the wager, plus their wager
    if [[ $win -eq 0 ]]; then
        winnings=$(( $1 * 5 ))
        printf "$greentext Congratulations! You have won \$%i on this game of Blackjack.\n $normal" $winnings
        ((money=$2+$winnings))
        # If they went bust or called it quits, they lose their wager
    else
        printf "$red$bold Better luck next time!$normal You spent \$%i on this game of Blackjack.\n" $1
        ((money=$2-$1))
    fi
}


# It's GAMBLIN' TIME
echo "Welcome to the Casino!"

# Set initial money - random, between 10 and 100
money=$(( 10 + $RANDOM % 91 ))
printf "You have \$%i to play with.\n" $money

# Set game counter
declare -i game=1

# While you still have money, and you've played 10 or fewer games
while [[ $money -gt 0 ]] && [[ $game -lt 11 ]]
do
    # Print the game counter
    printf "$bold \nGame $game $normal"
    # Set wager, random amount from whatever money we have left
    wager=$(( 1 + $RANDOM % $money ))
    # Play blackjack!
    blackjack $wager $money
    # Increment the game counter
    ((game++))
    # Tell the player how much money they have left
    printf "You have \$%i remaining.\n" $money
done