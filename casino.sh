#!/usr/bin/env bash

# Set some text colours
greentext="\033[32m"
bold="\033[1m"
normal="\033[0m"
ulinered="\033[4;31;40m"
red="\033[31;40m"

# Define a wager prompt
wagerprompt(){
    # Prompt for a wager
    read -p "How much would you like to wager? " wager
    # If no wager was set, set a random amount from the money the have remaining
    if [[ -z $wager ]]; then
        echo "No wager set. A random wager will be selected from your remaining money!"
        wager=$(( 1 + $RANDOM % $money ))
    fi
    # If the wager was greater than the money they have remaining, prompt again
    while [[ $wager -gt $money ]];
    do
        echo "Sorry, you've tried to wager more money than you have remaining."
        read -p "How much would you like to wager? " wager
    done
    printf "You have wagered \$%i on this game.\n" $wager
}

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
        echo -e "$bold $ulinered Bust!$normal$red Your score was $score. $normal"
        keepplaying=1
        win=1
        
        # If they did not win and are not bust, just print out the score
    else
        echo -e "Current score: $1."
        keepplaying=0
        win=1
    fi
}


## Games
# Blackjack
blackjack(){
    # Echo the name of the game and your wager
    echo -e "\nWelcome to the Blackjack table!"
    
    # Set the odds (can be anything from 2:1 to 10:1)
    odds=$(( 2 + $RANDOM % 9 ))
    echo "The odds on this game are $odds:1"
    
    # prompt for a wager
    wagerprompt
    
    # Set lists of the suits and cards
    suit=( Clubs Diamonds Spades Hearts )
    card=( 2 3 4 5 6 7 8 9 10 Jack Queen King Ace )
    
    # Set the values of the cards
    declare -A values
    values[2]=2;    values[3]=3;    values[4]=4;    values[5]=5;    values[6]=6
    values[7]=7;    values[8]=8;    values[9]=9;    values[10]=10;  values[Jack]=10
    values[Queen]=10;               values[King]=10;                values[Ace]=11
    #### Modify this. If Ace comes up, give the user the option to select its worth.
    
    # Set initial score to 0
    declare -i score=0
    # Set number of cards in hand
    declare -i cardsinhand=0
    
    # Print the progress of the game
    echo "Dealing..."
    # Make them wait
    sleep 2
    
    # List of cards already in your hand (so we play the game without replacement)
    declare -a cardlist=()
    
    # Get the suits of the two cards that were dealt
    for i in 1 2
    do
        # Random Suit
        local -i rand_suit=$[$RANDOM % ${#suit[@]}]
        # Random Card number - give a number for the index in the list of card names, NOT the card name
        local -i rand_card=$[$RANDOM % ${#card[@]}]
        # Generate the card name
        cardname="${card[$rand_card]} of ${suit[$rand_suit]}"
        
        # If that combo has already been dealt, try again
        while [[ ${cardlist[@]} =~ $cardname ]]
        do
            local -i rand_suit=$[$RANDOM % ${#suit[@]}]
            local -i rand_card=$[$RANDOM % ${#card[@]}]
            cardname="${card[$rand_card]} of ${suit[$rand_suit]}"
        done
        
        # Append that cardname to the list of cardnames to check against
        cardlist+=($cardname)
        # Print to user the card they were dealt
        echo "Card $i: $cardname"
        # Calculate score, add one more card to hand
        ((score+=${values[${card[$rand_card]}]}))
        ((cardsinhand++))
    done
    
    # Print progress of game
    echo "Dealt. Calculating score of dealt hand..."
    
    # Score test
    scoretest $score
    
    # If they did not win or lose, ask if they want to keep playing.
    while [[ $win -eq 1 && $keepplaying -eq 0 ]];
    do
        echo "Would you like to draw another card?"
        select cont in "Yes" "No"
        do
            case $cont in
                yes|Y|YES|Yes|y) echo "Drawing another card..."
                    # Make them wait
                    sleep 2
                    # Random Suit
                    local -i rand_suit=$[$RANDOM % ${#suit[@]}]
                    # Random Card - give a number for the index in the list of card names, NOT the card name
                    local -i rand_card=$[$RANDOM % ${#card[@]}]
                    
                    # Generate the card name
                    cardname="${card[$rand_card]} of ${suit[$rand_suit]}"
                    
                    # If that combo has already been dealt, try again
                    while [[ ${cardlist[@]} =~ $cardname ]]
                    do
                        local -i rand_suit=$[$RANDOM % ${#suit[@]}]
                        local -i rand_card=$[$RANDOM % ${#card[@]}]
                        cardname="${card[$rand_card]} of ${suit[$rand_suit]}"
                    done
                    # Append that cardname to the list of cardnames to check against
                    cardlist+=($cardname)
                    # Increment the card counter
                    ((cardsinhand++))
                    # Print to user the card they were dealt
                    echo "Card $cardsinhand: $cardname"
                    # Calculate score, add one more card to hand
                    ((score+=${values[${card[$rand_card]}]}))
                    # Test the score
                    scoretest $score
                    break
                ;;
                # If they select no, and decide to withdraw from the game
                no|N|NO|No|n) echo "You've chosen not to draw another card.";
                    keepplaying=1
                    win=1
                    break
                ;;
                *) echo "Unknown option. Please select yes or no."
            esac
        done
    done
    
    # If they got blackjack, they win some more money based on the odds from the start of the game.
    if [[ $win -eq 0 ]]; then
        winnings=$(( $wager * $odds ))
        printf "$greentext Congratulations! You have won \$%i on this game of Blackjack.\n $normal" $winnings
        ((money=$money+$winnings))
        # If they went bust or called it quits, they lose their wager
        elif [[ $win -eq 1 && $keepplaying -eq 1 ]]; then
        printf "$red$bold Better luck next time!$normal You spent \$%i on this game of Blackjack.\n" $wager
        ((money=$money-$wager))
    fi
}

# Function to run the slot machine - takes the game number as input
runslots(){
    
    # Set the array to the correct emoji array
    if [[ $1 -eq 1 ]]; then
        arr=( "🍉" "🍒" "🥥" "🍓" "🫐" "🍑" "🍏" "🍍" )
        greet=$bold"Slot machine 1: Fruit!$normal"
        elif [[ $1 -eq 2 ]]; then
        arr=( "🐘" "🦭" "🐖" "🦊" "🦔" "🐧" "🐅" "🦫" )
        greet=$bold"Slot machine 2: Animals! $normal"
        elif [[ $1 -eq 3 ]]; then
        arr=( "🫧" "🧼" "🧻" "🧹" "🧴" "🛁" "🧽" "🚽" )
        greet=$bold"Slot machine 3: Cleaning! $normal"
    fi
    
    # Get the index of each icon to be displayed
    slot1=$(($RANDOM % ${#arr[@]}))
    slot2=$(($RANDOM % ${#arr[@]}))
    slot3=$(($RANDOM % ${#arr[@]}))
    
    # Pull the one armed bandit
    echo -e "\n" $greet
    echo -e "Pulling the one-armed bandit...\n"
    sleep 2
    # Display the slots
    printf "\t${arr[$slot1]}" ; sleep 1
    printf "\t${arr[$slot2]}" ; sleep 1
    printf "\t${arr[$slot3]}"
    echo -e "\n"
    
    # If the slot numbers are all equal, you won!
    if [[ $slot1 -eq $slot2 && $slot1 -eq $slot3 ]]; then
        win=0
        # If they're not all equal, you lost this round
    else
        win=1
    fi
}


# Slots
slots(){
    # Welcome the player to the slots machine
    echo "Welcome to the slot machines!"
    echo "With each wager you put down, you'll be able to play up to 3 rounds on the slot machines."
    
    # Set the odds (can be anything from 20:1 to 100:1)
    odds=$(( 20 + $RANDOM % 81 ))
    echo "The odds on this game are $odds:1"
    
    # prompt for a wager
    wagerprompt
    
    # Set inital win value to 1, game number to 1
    win=1
    round=1
    
    # While we haven't won, and we're on our first, second, or third go
    while [[ $win -eq 1 && $round -lt 4 ]]
    do
        # Pull the one-armed bandit again
        runslots $round
        # Iterate the game counter
        ((round++))
    done
    
    # Finish the game
    #echo one line for aesthetics
    echo
    # if they won, given them some money
    if [[ $win -eq 0 ]]; then
        winnings=$(( $wager * $odds ))
        printf "$greentext Congratulations! You have won \$%i on this game of Slots.\n $normal" $winnings
        ((money=$money+$winnings))
        # If they lost, take their money
    else
        printf "$red$bold Better luck next time!$normal You spent \$%i on this game of Slots.\n" $wager
        ((money=$money-$wager))
    fi
}


#####################
### START PLAYING ###
#####################

# Get the player's name
read -p "What's your name? " name
# If they don't give an answer, prompt them again
while [[ -z $name ]]
do
    read -p "Please enter your name. " name
done

# Get the player's age
read -p "Thanks. What is your age? " age
# If they don't give an answer, prompt them again
while [[ -z $age ]]
do
    read -p "Please enter your age. " age
done
# If the player is under 18, exit!
if [[ $age -lt 18 ]]; then
    echo "Sorry, $name, you're too young to be in a casino!"
    exit 0
    # Otherwise, welcome them to the casino
else
    echo "Welcome to the Casino, $name!"
fi

# How much money will they be playing with?
if [[ -z $money ]]; then
    read -p "How much money would you like to bring into the casino? " money
    # If they don't give an answer, prompt them again
    while [[ -z $money ]]
    do
        read -p "Please enter amount of money you will be playing with. " money
    done
fi

# How many games will they be playing?
if [[ -z $numgames ]]; then
    read -p "How many games would you like to play? " numgames
    # If they don't give an answer, prompt them again
    while [[ -z $numgames ]]
    do
        read -p "Please enter the number of games you'd like to play. " numgames
    done
fi

# Inital money was earlier
printf "You have \$%i to play with.\n" $money

# Set game counter
declare -i gamenum=1

# While you still have money, and you've played fewer than the maximum number of games
while [[ $money -gt 0 ]] && [[ $gamenum -lt $(($numgames+1)) ]]
do
    # Print the game counter
    printf "$bold \nGame $gamenum $normal \n"
    echo "Which game would you like to play?"
    
    # Select the game you want to play
    select game in "Blackjack" "Slots" "Quit"
    do
        case $game in
            # If blackjack was selected, play blackjack
            Blackjack)
                # Play blackjack
                blackjack
                # Increment the game counter
                ((gamenum++))
                # Print to the player how much money they have left
                printf "You have \$%i remaining.\n" $money
                break
            ;;
            
            # If sots was selected, play slots
            Slots)
                # Play slots
                slots
                # Increment the game counter
                ((gamenum++))
                # Print to the player how much money they have left
                printf "You have \$%i remaining.\n" $money
                break
            ;;
            
            Quit) echo "Sorry to see you go!"; exit 0
            ;;
            
            *) echo "Sorry, we don't have that game here."
            ;;
        esac
    done
done