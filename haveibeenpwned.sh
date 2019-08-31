#!/bin/bash

#Author: Johnny Rios
#Nickname: shd0w

#Usage: ./haveibeenpwned.sh textpasswd
#<WORDLIST> COMING SOON

if [[ -n $1 ]]; then
	if [[ -f $1  ]]; then #TRUE IF ENTERED WORDLIST
		echo "[+] Searching for leaked passwords";
		for line in $(cat $1); do
			pass=$(echo -n $line | sha1sum | awk '{print substr($line,0,5)}');
			fullpass=$(echo -n $line | sha1sum | awk '{print substr($line,6,35)}');
			count=$(curl -s https://api.pwnedpasswords.com/range/$pass | grep -i $fullpass | cut -d ":" -f2);
			if [[ -n $2 ]]; then
				if [[ -f $2 ]]; then
					if [[ -n $count  ]]; then
						echo -e  "$line:$count" >> $2;
					else
						echo -e "$line:" >> $2;
					fi
				else
					if [[ -n $count  ]]; then
						echo "Criando arquivo em $(pwd)/$2";
						touch $2;
						echo "$line:$count" >> $2;
					else
						echo "$line:0" >> $2;
					fi
				fi
			else
				if [[ -n $count ]]; then
					echo -e "$line:$count";
				else
					echo -e "$line:0";
				fi
			fi
		
		done
	else
		if [ ! -z $1  ]; then
			pass=$(echo -n $1 | sha1sum | awk '{print substr($1,0,5)}'); #GET THE FIRST 5 POSITIONS OF THE PASSWORD AS REQUIRED THE API
			contpass=$(echo -n $1 | sha1sum | awk '{print substr($1,6,35)}'); #GET THE LAST POSITIONS OF THE PASSWORD
			echo -e -n "[+] Searching for $1";
			echo
			count=$(curl -s https://api.pwnedpasswords.com/range/$pass | grep -i $contpass  | cut -d ":" -f2);
			if [[ -n $2 ]]; then
				if [[ -f $2 ]]; then
					if [[ -n $count  ]]; then
						echo -e  "$1:$count" >> $2;
					else
						echo -e "$1:" >> $2;
					fi
				else
					if [[ -n $count  ]]; then
						echo "Criando arquivo em $(pwd)/$2";
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
		
		fi
	fi
else
	echo -e "USAGE: $0 textpassword <output file>";
fi
