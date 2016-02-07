#! /bin/bash
#usage: base_dir_to_process

base_dir=$1
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
		walk_dir "$i"
	else
		abs_path=$(readlink -f "${i}")		#absolute path to file
		find_dupl "$abs_path" $base_dir
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
			find_dupl "$1" "$i"
			cd "$2"
		else
			diff "$1" "$i" > /dev/null
			if [ $? -eq 0 -a ! "$1" -ef "$i" ]
			then
				abs_file_path=$(readlink -f "${i}")
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
walk_dir $base_dir

#Cleanup empty folders
