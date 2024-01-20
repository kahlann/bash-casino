#!/usr/bin/env bash

# Prompt for a string
read -p "Enter a string with only alphabet characters and spaces: " string1

# Check that input only contains alphabet characters or spaces
if [[ ! $string1 =~ ^[a-zA-Z[:blank:]]+$ ]]; then
    echo "Entry contains something other than alphabet characters and spaces."
else
    echo "Valid string."
fi

# Prompt for a number
read -p "Enter number: " num1
# Check that input only contains numbers (must be integer) and does not have a leading 0, must be less than 2^32
if [[ ! $num1 =~ ^[0-9]+$ ]] || [[ ${num1:0:1} -eq 0 ]] || [[ $num1 -gt $((2^32)) ]]; then
    echo "Invalid number - may have a leading 0, be greater than 2^32, or contain non-numeric characters."
else
    echo "Valid number."
fi