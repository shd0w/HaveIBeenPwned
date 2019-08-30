#!/bin/bash

#Author: Johnny Rios
#Nickname: shd0w
#Date: 30/08/2019

#Usage: ./haveibeenpwned.sh textpasswd
#<WORDLIST> AND <OUTPUTFILE> COMING SOON

if [ ! -z $1  ]; then
	pass=$(echo -n $1 | sha1sum | awk '{print substr($1,0,5)}'); #GET THE FIRST 5 POSITIONS OF THE PASSWORD AS REQUIRED THE API
	contpass=$(echo -n $1 | sha1sum | awk '{print substr($1,6,35)}'); #GET THE LAST POSITIONS OF THE PASSWORD
	echo -e -n "[+] SEARCHING...";
	echo
	#echo $contpass
	count=$(curl -s https://api.pwnedpasswords.com/range/$pass | grep -i $contpass  | cut -d ":" -f2);
	
	if [[ -n $2 ]]; then
		if [[ -f $2 ]]; then
			if [[ -n $count  ]]; then
				echo -e  "$1: LEAKED $count TIMES" >> $2;
			else
				echo -e "$1:LEAKED 0 TIMES" >> $2;
			fi
		else
			if [[ -n $count  ]]; then
				echo "CRIANDO ARQUIVO $2";
				echo "$1:$count" > $2;
			else
				echo "$1:0" > $2;
			fi
		fi	
	else
		if [[ -n $count ]]; then
			echo -e "$1:$count";
		else
			echo -e "$1:0";
		fi
	fi
else
	echo -e "USAGE: $0 textpassword";
fi

