#!/bin/bash

set -f
programName=`basename $0`

showUsage() {
	echo "USAGE: $programName <file> (<file>) ... (<file>)"
	echo "  Make all file arguments ignored by svn."
    echo "  OPTIONS:"
	echo "    -v                   - List each file ignored"
	echo "USAGE: $programName -l"
    echo "  Recursively list all files currently in svn:ignore"
	echo "USAGE: $programName -f <file>"
    echo "  Adds all files listed in <file> to svn:ignore"
    exit 2
}

verbose=""
list=""
fromFilesList=""
filesList=""
while getopts "vlf:" options; do
  case $options in
    v ) 
		verbose="yes" ;;
    l ) 
		list="yes" ;;
  	f )
  		fromFilesList="yes"
  		filesList=$OPTARG ;;
    * ) 
		showUsage ;;
  esac
done
shift $((OPTIND - 1))

if [ "$list" ]; then
	dirs=`find . -type d -not -path '*/.svn*'`
	for dirName in $dirs; do
		svnIgnore=`svn propget svn:ignore $dirName 2>/dev/null`
		if [ "$svnIgnore" ]; then
			for fileName in $svnIgnore; do
				echo "$dirName/$fileName"
			done
		fi
	done
elif [ "$fromFilesList" ]; then
	if [ -f "$filesList" ]; then
		cat $filesList | xargs $0 -v 
	else
		echo "ERROR: Couldn't read files list '$filesList'"
	fi
elif [ -n "$*" ]; then
	for fileName in $*; do
		fileBaseName=`basename "$fileName"`
		fileDirName=`dirname "$fileName"`
		if [ -z "$fileDirName" ]; then
			fileDirName=.
		fi
		currentProperty=`svn propget svn:ignore "$fileDirName"`
		alreadyThere=""
		if [ -n "$currentProperty" ]; then
			alreadyThere=`echo "$currentProperty" | grep "$fileBaseName\$"`
			currentProperty="$currentProperty
"
		fi
		if [ -z "$alreadyThere" ]; then
			if [ -n "$verbose" ]; then
				echo "Added '$fileName'"
			fi
			svn -q propset svn:ignore "$currentProperty$fileBaseName" "$fileDirName" 
		else
			if [ -n "$verbose" ]; then
				echo "Already ignoring '$fileName'"
			fi
		fi
	done
else
	 showUsage
fi