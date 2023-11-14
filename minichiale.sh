#!/bin/bash

# Specify the file you want to read / write
file="bash_lines.txt"
red="\033[31m"
green="\033[32m"
endc="\033[0m"

# Check if the file exists
if [ -e "$file" ]; then
    # Open the file for reading
	exec 3< "$file"
#	exec 4< "$file"
#	exec 5> "$output_mini"
#	exec 6> "output_bash"
    # Read each line from the file and execute a command (replace 'your_command' with the actual command)
	while read -r line <&3; do
		echo -e "----------"
		echo -e "$line"
    		exec_mini="../minishell"
		output_mini=$("$exec_mini" "-c" "$line")
		output_bash=$(eval "$line")
		if [ "$output_mini" != "$output_bash" ]; then
			diff_output=$(diff -y --suppress-common-lines <(echo "$output_mini") <(echo "$output_bash"))
			echo -e "${red}Difference detected!${endc}"
			echo -e "$diff_output"
	else
			echo -e " ${green}Same!${endc}"
	fi
#		echo -e "mini output: ($output_mini)"
#		echo -e "bash output: ($output_bash)"
	done
else
	echo "File not found: $file"
fi
