#!/bin/bash

# Specify the file you want to read / write
file1="bash_lines1.txt"
file2="bash_lines2.txt"
dir_mini="./dir_mini"
dir_bash="./dir_bash"
dir_org=$(pwd)
red="\033[31m"
green="\033[32m"
endc="\033[0m"
exec_mini="./minishell"

# Check if the file exists
if [ -e "$file1" ]; then
    # Open the file for reading
	exec 3< "$file1"
	exec 4< "$file2"
#	mkdir "$dir_mini"
#	mkdir "$dir_bash"
	cp -r ../minishell ./
	cp -r minishell dir_mini/
#	exec 4< "$file"
#	exec 5> "$output_mini"
#	exec 6> "output_bash"
    # Read each line from the file and execute a command (replace 'your_command' with the actual command)
	while read -r line <&3; do
		echo -e "----------"
		echo -e "$line"
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
	while read -r line <&4; do
		echo -e "----------"
		echo -e "$line"
		cd "$dir_mini"
		output_mini=$("$exec_mini" "-c" "$line")
		cd "$dir_org"
		cd "$dir_bash"
		output_bash=$(eval "$line")
		cd "$dir_org"
		if [ "$output_mini" != "$output_bash" ]; then
			diff_output=$(diff -y --suppress-common-lines <(echo "$output_mini") <(echo "$output_bash"))
			echo -e "${red}Difference detected!${endc}" 
			echo -e "$diff_output"
	else
			echo -e " ${green}Same!${endc}"
	fi
	#echo -e "mini output: ($output_mini)"
	#echo -e "bash output: ($output_bash)"
	done

else
	echo "File not found: $file"
fi
