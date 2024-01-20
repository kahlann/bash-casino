#!/usr/bin/env bash

################
### PREAMBLE ###
################

# Set some text colours
# Green text
greentext="\033[32m"
# Bold
bold="\033[1m"
# Regular text
normal="\033[0m"
# Underlined
ulinered="\033[4;31;40m"
# red text with black background
red="\033[31;40m"

# Regex for a valid name
validname="^[a-zA-Z[:blank:]]+$"

# Maximum value for anything
maxval=$((2**32))

########################
### DEFINE FUNCTIONS ###
########################
# Test function - did they enter a name?
# First argument must be the name variable
nametest(){
    # If they did not enter a name, or the input contains something other than alpha caharcters, iterate the counter for the next message
    if [[ ! $name =~ $validname ]] || [[ -z $1 ]]; then
        ((i++))
        # if the name is valid, set the name variable to that input string
    else
        name=$1
    fi
}

# Test function - did they enter a valid age?
# First argument must be the age variable
agetest(){
    # If the age is not greater than 0, does not exist, is not an integer, has a leading 0 (will be interprested as an octal number), or greater than/equal to 2^32, iterate the counter for the next message
    if [[ ! $1 -gt 0 ]] | [[ -z $1  ]] || [[ ! $1 =~ ^[0-9]+$ ]] || [[ ${1:0:1} -eq 0 ]] || [[ $1 -ge $maxval ]]; then
        ((i++))
        # If it's a valid age, set the age variable to that input
    else
        age=$1
    fi
}

# Function to get the player's name
getname(){
    # Request the player's name
    read -p "What's your name? " name
    
    # If they don't give an answer, start a counter and prompt them again
    declare -i i=0
    
    # Keep prompting for a name
    while [[ i -lt 10 && (-z $name || ! $name =~ $validname)]]
    do
        # The prompt will depend on how many times they've already been asked
        case $i in
            0) read -p "Please enter your name. " name
            nametest $name;;
            1) read -p "Please enter your name! " name
            nametest $name;;
            2) read -p "Are you taking the piss? Enter your name! " name
            nametest $name;;
            3) read -p "C'mon, man! If you don't want to play just hit Ctrl+C. Otherwise, enter your name: " name
            nametest $name;;
            4) read -p "Are you for real? Final chance! Enter your name: " name
            nametest $name;;
            5) read -p "OK you called my bluff. But this is your last chance! Name here: " name
            nametest $name;;
            6) exit 0
        esac
    done
    # If they do enter a name, say thank you!
    printf "Thanks. "
}

# Function to get the player's age, and determine if they are old enough to play
getage(){
    # Prompt for the player's name
    read -p "How old are you? " age
    
    # If they don't give an answer, start a counter, prompt them again
    declare -i i=0
    
    # Keep prompting for an age
    firstletter=${word:0:1}
    while [[ i -lt 10 && -z $age ]] || [[ i -lt 10 && $age -lt 0 ]] || [[ ! $age =~ ^[0-9]+$ ]] || [[ ${age:0:1} -eq 0 ]] || [[ $age -ge $maxval ]]
    do
        # The prompt will depend on how many times they've already been asked
        case $i in
            0) read -p "Please enter your age. " age
            agetest $age;;
            1) read -p "Please stop messing around, enter your age! " age
            agetest $age;;
            2) read -p "Are you taking the piss? Enter your age! " age
            agetest $age;;
            3) read -p "C'mon, man! If you don't want to play just hit Ctrl+C. Otherwise, enter your age: " age
            agetest $age;;
            4) read -p "Are you for real? Final chance! Enter your age: " age
            agetest $age;;
            5) read -p "OK you called my bluff. But this is your last chance! Age here: " age
            agetest $age;;
            6) exit 0
        esac
    done
    
    # If they did enter an age, was the age less than 18?
    if [[ $age -lt 18 ]]; then
        # If they're a minor, kick 'em out!
        echo "Sorry, $name, you're too young to be in a casino!"
        exit 0
        # Otherwise, welcome them to the casino
    else
        echo -e "\n🎲\tWelcome to The Bash Casino, $name!\t🎲"
    fi
}

# Test function - money
# First argument must be the money variable
moneytest(){
    # If they did not enter a value, the value was less than 0, is not an integer, or has a leading 0 (interpreted as an octal), increment the counter for a new message
    if [[ -z $1 ]] || [[ $1 -le 0 ]] || [[ ! $1 =~ ^[0-9]+$ ]] || [[ ${1:0:1} -eq 0 ]] || [[ $1 -ge $maxval ]]; then
        ((i++))
        # If they did enter a valid number, that number is the amount of money they bring in
    else
        money=$1
    fi
}

# Test function - did they enter a valid number of games?
# First argument must be the numgames variable
gamestest(){
    # If they did not enter a value, the value was less than 0, not an integer, or has a leading 0 (interpreted as an octal), increment the counter for a new message
    if [[ $1 -le 0 ]] || [[ -z $1 ]] || [[ ! $1 =~ ^[0-9]+$ ]] || [[ ${1:0:1} -eq 0 ]] || [[ $1 -ge $maxval ]]; then
        ((i++))
        # If they did enter a valid number, that number is the number of games they play
    else
        declare -i numgames=$1
    fi
}

# Function to get the money to bring into the casino
getmoney(){
    # prompt the user to tell us how much money they're brining in
    read -p "How much money would you like to bring into the casino? " money
    
    # If they don't give an answer, start a counter and prompt them again
    declare -i i=0
    
    # Keep prompting for money
    while [[ i -lt 10 && -z $money ]] || [[ i -lt 10 && $money -le 0 ]] || [[ ! $money =~ ^[0-9]+$ ]] || [[ ${money:0:1} -eq 0 ]] || [[ $money -ge $maxval ]]
    do
        # The prompt will depend on how many times they've already been asked
        case $i in
            0) read -p "Please enter the amount of money you'd like to bring into the casino. " money
            moneytest $money;;
            1) read -p "Please stop stop messing around, enter a number! " money
            moneytest $money;;
            2) read -p "Are you taking the piss? Give us your money! " money
            moneytest $money;;
            3) read -p "C'mon, man! If you don't want to play just hit Ctrl+C. Otherwise, enter a monetary value: " money
            moneytest $money;;
            4) read -p "Are you for real? Final chance! Enter the amount of money: " money
            moneytest $money;;
            5) read -p "OK you called my bluff. But this is your last chance! Money here: " money
            moneytest $money;;
            6) exit 0
        esac
    done
    # If they do enter a value, say thank you!
    printf "Thanks. "
}

# Function to get the number of games
getgames(){
    # Prompt for the number of games
    read -p "How many games would you like to play? " numgames
    
    # If they don't give an answer, start a counter, prompt them again
    declare -i i=0
    
    # Keep prompting for number of games
    while [[ i -lt 10 && -z $numgames ]] || [[ i -lt 10 && $numgames -le 0 ]] || [[ ! $numgames =~ ^[0-9]+$ ]] || [[ ${numgames:0:1} -eq 0 ]] || [[ $numgames -ge $maxval ]]
    do
        # The prompt will depend on how many times they've already been asked
        case $i in
            0) read -p "Please enter the number of games you'd like to play. " numgames
            gamestest $numgames;;
            1) read -p "Please stop messing around, enter a valid number of games! " numgames
            gamestest $numgames;;
            2) read -p "Are you taking the piss? Enter the number of games! " numgames
            gamestest $numgames;;
            3) read -p "C'mon, man! If you don't want to play just hit Ctrl+C. Otherwise, enter the number of games: " numgames
            gamestest $numgames;;
            4) read -p "Are you for real? Final chance! Enter the number of games: " numgames
            gamestest $numgames;;
            5) read -p "OK you called my bluff. But this is your last chance! Number of games here: " numgames
            gamestest $numgames;;
            6) exit 0
        esac
    done
}

# Define a function that prompts for a wager
wagerprompt(){
    # Prompt for a wager
    read -p "How much would you like to wager? " wager
    # counter for how many times we've asked for a wager
    declare -i i=0
    # If they enter a wager that is not an integer or has a leading 0
    while ([[ ! $wager =~ ^[0-9]+$ ]] || [[ ${wager:0:1} -eq 0 ]] || [[ -z $wager ]] || [[ $wager -eq 0 ]] || [[ $wager -ge $maxval ]] || [[ $wager -gt $money ]]) && [[ i -lt 3 ]]
    do
        # Increment the counter for number of prompts
        ((i++))
        # If the entry was missing, not integer, had a leading 0, or less than 0
        if ([[ ! $wager =~ ^[0-9]+$ ]] || [[ ${wager:0:1} -eq 0 ]] || [[ -z $wager ]] || [[ $wager -eq 0 ]]); then
            read -p "Please enter an integer value for your wager." wager
            # If the wager was too big (largr than bash will allow, or larger than the remaining money)
            elif [[ $wager -ge $maxval ]] || [[ $wager -gt $money ]]; then
            echo "Sorry, you've tried to wager more money than you have remaining."
            read -p "How much would you like to wager? " wager
        fi
    done
    printf "You have wagered \$%i on this game.\n" $wager
    
    # If no wager was set above (after 3 prompts), set a random amount from the money the have remaining
    if ([[ ! $wager =~ ^[0-9]+$ ]] || [[ ${wager:0:1} -eq 0 ]] || [[ -z $wager ]] || [[ $wager -eq 0 ]] || [[ $wager -ge $maxval ]]) && [[ i -eq 3 ]]; then
        echo "No wager set. A random wager will be selected from your remaining money!"
        wager=$(( 1 + $RANDOM % $money ))
    fi
}

# Blackjack score test
scoretest(){
    # Make them wait
    sleep 2
    # If the score is 21 (blackjack)
    if [[ $1 -eq 21 ]]; then
        echo -e $greentext$bold "Blackjack!" $normal
        keepplaying=1
        win=0
        
        # If the score is > 21 (bust)
        elif [[ $1 -gt 21 ]]; then
        echo -e $bold $ulinered "Bust!" $normal $red "Your score was $totalscore." $normal
        keepplaying=1
        win=1
        
        # If they did not win and are not bust, just print out the score
    else
        echo -e "Current score: $totalscore."
        keepplaying=0
        win=1
    fi
}

# Define a function to adjust the score if there's an ace in their hand
# Takes the acescore as input
ace(){
    # Set inital ace score to 0
    declare -i acescore=0
    # If there are aces in your hand
    if [[ ${cardlist[@]} =~ "Ace" ]]; then
        # Get how many aces there are
        declare -i acecount=0
        for word in  ${cardlist[*]}; do
            if [[ $word =~ "Ace" ]]; then
                (( acecount++ ))
            fi
        done
        # Sanity check: If choosing the lowest value for all Aces will result in Bust, do not bother asking the user what their choice is
        if [[ $(( score + (acecount*1) )) -gt 21 ]]; then
            return $((acecount*1))
        else
            # Tell the user how many aces are in their hand
            if [[ $acecount -eq 1 ]]; then
                echo -e "There is $bold 1 $normal Ace in your hand. You need to choose what the ace is worth."
                elif [[ $acecount -gt 1 ]]; then
                echo -e "There are $bold $acecount $normal Aces in your hand. You need to choose what they are worth."
            fi
            
            # For each ace, ask the player what value that ace should take
            for ((i=1; i<=acecount; i++))
            do
                echo -e "Ace number $i. Choose how much you want it to be worth (1 or 11). Remember, you may have more than one ace to assign!"
                printf "If you choose 1, your running score will be $bold%i. $normal \n" $((score+acescore+1))
                printf "If you choose 11, your running score will be $bold%i.$normal \n" $((score+acescore+11))
                
                # Select the value to use
                select value in "1" "11"
                do
                    case $value in
                        # If 1 was selected, add 1 to the score
                        1|1) acescore=$acescore+1
                            break
                        ;;
                        
                        # If 11 was selected, add 11 to the score
                        11|2) acescore=$acescore+11
                            break
                        ;;
                        # If they input anything else, prompt them to choose one of the options.
                        *) echo "Please select a value for the Ace card(s)."
                        ;;
                    esac
                done
            done
        fi
    fi
    return $acescore
}


## Games
# Blackjack
blackjack(){
    # Echo the name of the game and your wager
    echo -e $bold "\nWelcome to the Blackjack table!" $normal
    
    # Set the odds (can be anything from 5:1 to 20:1)
    odds=$(( 5 + $RANDOM % 16 ))
    echo -e "The odds on this game are" $bold "$odds:1" $normal
    
    # prompt for a wager
    wagerprompt
    
    # Set lists of the suits and cards
    suit=( Clubs Diamonds Spades Hearts )
    card=( 2 3 4 5 6 7 8 9 10 Jack Queen King Ace )
    
    # Set the values of the cards
    declare -A values
    values[2]=2;    values[3]=3;    values[4]=4;    values[5]=5;    values[6]=6
    values[7]=7;    values[8]=8;    values[9]=9;    values[10]=10;  values[Jack]=10
    values[Queen]=10;               values[King]=10;                values[Ace]=0
    
    # Set initial score for all cards except Aces to 0
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
    
    # Check if there were aces drawn, and if so let the user select the values
    ace
    acescore=$?
    
    # Get the total score
    declare -i totalscore=$score+$acescore
    
    # Score test
    scoretest $totalscore
    
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
                    # Check if there were any aces which we need to assign a value to
                    ace
                    acescore=$?
                    
                    # Get the total score
                    declare -i totalscore=$score+$acescore
                    
                    # Score test
                    scoretest $totalscore
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
        echo -e $greentext "Congratulations! You have won \$$winnings on this game of Blackjack." $normal
        ((money=$money+$winnings))
        # If they went bust or called it quits, they lose their wager
        elif [[ $win -eq 1 && $keepplaying -eq 1 ]]; then
        echo -e $red $bold "Better luck next time!" $normal "You spent \$$wager on this game of Blackjack."
        ((money=$money-$wager))
    fi
}

# Function to run the slot machine - takes the game number as input
runslots(){
    
    # Set the array to the correct emoji array
    if [[ $1 -eq 1 ]]; then
        arr=( "🍉" "🍒" "🥥" "🍓" "🫐" "🍑" "🍏" "🍍" )
        greet="Slot machine 1: Fruit!"
        elif [[ $1 -eq 2 ]]; then
        arr=( "🐘" "🦭" "🐖" "🦊" "🦔" "🐧" "🐅" "🦫" )
        greet="Slot machine 2: Animals!"
        elif [[ $1 -eq 3 ]]; then
        arr=( "🫧" "🧼" "🧻" "🧹" "🧴" "🛁" "🧽" "🚽" )
        greet="Slot machine 3: Cleaning!"
    fi
    
    # Get the index of each icon to be displayed
    slot1=$(($RANDOM % ${#arr[@]}))
    slot2=$(($RANDOM % ${#arr[@]}))
    slot3=$(($RANDOM % ${#arr[@]}))
    
    # Pull the one armed bandit
    echo -e "\n$bold$greet$normal"
    echo -e "Pulling the one-armed bandit...\n"
    sleep 2
    # Display the slots
    printf "\t${arr[$slot1]}" ; sleep 1
    printf "\t${arr[$slot2]}" ; sleep 1
    printf "\t${arr[$slot3]}" ; sleep 1
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
    echo -e $bold "\nWelcome to the slot machines!" $normal
    echo "With each wager you put down, you'll be able to play up to 3 rounds on the slot machines."
    
    # Set the odds (can be anything from 20:1 to 100:1)
    odds=$(( 20 + $RANDOM % 81 ))
    echo -e "The odds on this game are" $bold "$odds:1" $normal
    
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
        echo -e $greentext $bold "Congratulations! $normal You have won \$$winnings on this game of Slots." $normal
        ((money=$money+$winnings))
        # If they lost, take their money
    else
        echo -e $red $bold "Better luck next time!" $normal " You spent \$$wager on this game of Slots."
        ((money=$money-$wager))
    fi
}


#####################
### START PLAYING ###
#####################

# Get the player's name
getname

# Get the player's age
getage

# How much money will they be playing with?
getmoney

# How many games will the be playing?
getgames

# Inital money - print to user
printf "You have \$%i to play with, and have opted to play %i games.\n" $money $numgames

# assign to a variable so we can tell the user how much they lost/won at the end
initmoney=$money

# Set game counter
declare -i gamenum=1

# While you still have money, and you've played fewer than the maximum number of games
while [[ $money -gt 0 && $gamenum -lt $(($numgames+1)) ]]
do
    # Print the game counter
    echo -e "$bold\nGame $gamenum $normal"
    echo -e "Which game would you like to play?"
    
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
                # Make them wait
                sleep 2
                break
            ;;
            
            # If slots was selected, play slots
            Slots)
                # Play slots
                slots
                # Increment the game counter
                ((gamenum++))
                # Print to the player how much money they have left
                printf "You have \$%i remaining.\n" $money
                # Make them wait
                sleep 2
                break
            ;;
            
            Quit) echo "Sorry to see you go!"; exit 0
            ;;
            
            *) echo "Unknown selection. Please select a game or quit."
            ;;
        esac
    done
done


# Exit message
# echo for aesthetics
echo
# If they ran out of money before they had all their games, display a message to let them know they are being removed from the premises.
if [[ $money -eq 0 ]] && [[ $gamenum -lt $(($numgames+1)) ]]; then
    echo -e "$bold$ulinered$name, I'm sorry, but you're out of money. I'm going to have to ask you to leave! $normal"
    echo -e "You played $((gamenum-1)) of the $numgames you wanted to play. You spent $initmoney with us today."
    echo -e "Thank you for your business."
    
    # If they still have money left at the end of all the games, and it's more than they started with
    elif [[ $((money-initmoney)) -gt 0 ]] && [[ $gamenum -eq $(($numgames+1)) ]]; then
    congrats="Congratulations!"
    echo -e "$greentext$bold$congrats$normal$greentext You won \$$((money-initmoney)) in The Bash Casino! $normal"
    echo -e "You have played all $numgames games you set out to play."
    echo -e "Thank you for playing with us today, $name!"
    
    # If they finished all their games but spent all their money
    elif [[ $((money)) -eq 0 ]] && [[ $gamenum -eq $(($numgames+1)) ]]; then
    echo "You have played all $numgames games you set out to play."
    echo -e "You leave here having spent all of your money (\$$initmoney)."
    echo "Thank you for playing with us today, $name!"
    
    # If they still have money left at the end of all the games, but it's less than they started with
    elif [[ $((money-initmoney)) -lt 0 ]] && [[ $gamenum -eq $(($numgames+1)) ]]; then
    echo "You have played all $numgames games you set out to play."
    echo -e "While you won't be leaving totally broke, you did lose a total of $red$bold\$$((initmoney-money))$normal."
    echo "Thank you for playing with us today, $name!"
    
    # If they still have money left at the end of all the games, and it's the same as what they started with
    elif [[ $((money-initmoney)) -eq 0 ]] && [[ $gamenum -eq $(($numgames+1)) ]]; then
    echo "You have played all $numgames games you set out to play."
    echo "You have broken even, and you are leaving with the same amount of money you came in with (\$$initmoney)."
    echo "Thank you for playing with us today, $name!"
fi