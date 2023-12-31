#!/usr/bin/env bash
# Get the username
echo -e "Username: $(whoami)\n"

# Get the current working directory
echo -e "Working directory: $(pwd)\nFiles in this directory:\n"

greentext="\033[32m"
bold="\033[1m"
normal="\033[0m"

# Print the FILES in this directory and their size
declare -i counter=1
for i in $(ls);
do
    if [[ ! -d $i ]]
    then
        printf "$greentext$bold File %-0i:$normal \t%-s (%s)\n" $counter $i $(du $i -s -h | awk '{ printf("%s"), $1 }')
        ((counter++))
    fi
done


# Get the kernel
echo -e "\nKernel: $(uname -r)\n"

# Get the bash and python versions
echo -e "Bash version: $(bash --version | grep "GNU bash, version")\n"
echo -e "Python version: $(python -V)\n"

# Get percentage free memory
free -m | awk '/^Mem/ { printf("Free memory: %i MB (%.1f %)\n\n", $4, $4/$2 * 100.0) }'
# freemem=$(free -h | awk 'NR==2 {print $4}')

# Get disk space
df -h /dev/root | grep /dev/root | awk '/^dev/root { printf("Disk space free: %s (%s used)\n\n", $4, $5) }'
# freespace=$(df -h / | awk 'NR==2 {print $4}')

# Print the time and date
printf "Timestamp: %(%Y-%m-%d %H:%M:%S)T\n"
