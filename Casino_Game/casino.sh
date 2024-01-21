#!/usr/bin/env bash

# Import the other scripts that contain the prompts, games etc
source Casino_Game/formatting
source Casino_Game/prompts
source Casino_Game/blackjack
source Casino_Game/slots

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