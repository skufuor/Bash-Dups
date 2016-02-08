#! /bin/bash
#usage: base_dir_to_process

base_dir="$1"
debug=true
verbose=true

#Recursive function that walks the dir and processes files inside of it
#usage: cur_dir
function walk_dir {
cd "$1"
#echo "walk_dir: $1"

for i in *; do  #for each file in current directory
	if [ -d "$i" ]
	then
		abs_dir=$(readlink -e -- "$i")
#		walk_dir "$i"
#		ls -A "$abs_dir" >> /dev/null
#		if [ $? ];
		if [[ $(ls -A "$abs_dir") ]]
		then	
			walk_dir "$abs_dir"
			cd "$1"
		else
			echo "$abs_dir is empty"
		fi
	else
		abs_path=$(readlink -e -- "$i")		#absolute path to file
#		find_dupl "$abs_path" "$base_dir"
	fi
cd "$1"
done
}

#Recursive function that walks dir checking for duplicate binaries
#usage: file_to_check cur_dir
function find_dupl {
#	echo "finding duplicate for file: $1"

	cd "$2"
	for i in *; do
		if [ -d "$i" ]
		then
			abs_dir=$(readlink -e -- "$i")
#			find_dupl "$1" "$i"
#			ls -A "$abs_dir" >> /dev/null
#			if [ $? ]
			if [[ $(ls -A "$abs_dir") ]]
			then
				find_dupl "$1" "$abs_dir"
				cd "$2"
			fi
		else
			abs_file_path=$(readlink -e -- "$i")
			diff "$1" "$abs_file_path" >> /dev/null
			if [ $? -eq 0 -a ! "$1" -ef "$i" ]
			then
				process_dupl_file "$abs_file_path" # readlink -f "${i}"
			fi
		fi
	done	
}

#processes duplicate file, either logs or deletes based on flag
#usage: file_to_delete
function process_dupl_file {
	echo "processing duplicate file: $1"
}

#========================================

echo "Beginning cleanup of directory: $base_dir"
walk_dir "$base_dir"

#Cleanup empty folders
