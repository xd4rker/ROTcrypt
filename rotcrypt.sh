#!/bin/bash

# Author : XD4rker
# Email : xd4rker[at]gmail.com

# Display the help message
function display_help() {

	echo -e "\n"
	echo "Usage:"
	echo "------"
	echo ""
	echo "./rotcrypt.sh <Rotation number> [Options] <String>"
	echo ""
	echo "Options:"
	echo "--------"
	echo ""
	echo -e "-h\tShow this help"
	echo -e "-v\tVerbose mode. This parameter can only be combined with the -d parameter"
	echo -e "-e\tEncrypt a given string"
	echo -e "-d\tDecrypt a given string"
	echo ""
	echo "Examples:"
	echo "---------"
	echo ""
	echo -e "\t-> Decrypting a ROT-10 encrypted text"
	echo -e '\t   ./rotcrypt.sh 10 -d "drsc sc k cezob dyz combod wocckqo"'
	echo ""
	echo -e "\t-> Encrypting a text through ROT-8"
	echo -e '\t   ./rotcrypt.sh 8 -e "This is a super top secret message"'
	echo ""
	echo -e "\t-> If the ROT argument isn't set, the script will use ROT-13 by default"
	echo -e '\t   ./rotcrypt.sh -e "This is a super top secret message"'
	echo ""
	echo -e "\t-> This will decrypt the cypher based on letters' frequency (Works only with English alphabet) if the ROT argument isn't set"
	echo -e '\t   ./rotcrypt.sh -d "drsc sc k cezob dyz combod wocckqo"'
	echo ""
	echo -e "\t-> Using verbose mode"
	echo -e '\t   ./rotcrypt.sh -d "drsc sc k cezob dyz combod wocckqo" -v'
	echo ""
}

if [[ -z $1 ]]; then
	display_help
	exit
fi

# Calculate letters' frequency
function frequency() {

	array=( e t a o i n s h r d l c u m w f g y p b v k j x q z )

	declare -A letters

	for i in {0..25}; do
		letters[${array[$i]}]=$i
	done

	text=$1

	text_length=$(( `echo $text | wc -c` - 1 ))

	k=1
	n=0
	while (( k <= $text_length )); do
		letter=`echo $text | cut -c $k`
		n=$(( ${letters[$letter]} + $n ))
		k=$(( $k + 1 ))
	done

	echo $n

}

# Usage: encode <string> <number>
function encode() {

	str=`echo $1 | tr "A-Z" "a-z"`

	letters_array=( {a..z} )

	for l in {0..25}; do
		tr_regex[$l]="a-z "${letters_array[$l]}"-za-"${letters_array[$l-1]};
	done

	echo $str | tr ${tr_regex[$2]}

}

# Usage: decode <string> <number>
function decode() {

	str=`echo $1 | tr "A-Z" "a-z"`

	letters_array=( {a..z} )

	for n in {0..25}; do
		tr_regex[$n]=${letters_array[$n]}"-za-"${letters_array[$n-1]}" a-z"
	done
	
	echo $str | tr ${tr_regex[$2]}
}

function show_spaces() {

	length=$(( `echo $1 | wc -c` - 4 ))
	for ((a=1; a <= $length; a++)); do
	echo -n " "
	done
}

if (( $1 )); then
	first=$1
	shift
fi

while getopts :h:e:d:v opts; do
   case ${opts} in
   	e) Encode_str=${OPTARG} ;;
	d) Decode_str=${OPTARG} ;;
	v) Verbose=true;;
   esac
done

if [[ $1 == *-d* && $# -ge 2 ]]; then

	arg=`echo $Decode_str | tr " " "-"`

	if (( $first )); then
		decoded_str=`decode $arg $first`
		nn=$first
	else

		string=`decode $arg 0`
		freq=`frequency $string`
		nn=0
		decoded_str=$string

		for m in {1..25}; do

			string=`decode $arg $m`
			freq_test=`frequency $string`

			if [[ ! -z $Verbose ]]; then
				if [ $m -eq 1 ]; then
					echo ""
					echo -n "Outputs"
					show_spaces $string
					echo "frequency"
					echo ""
				fi
				
				echo $string "  " $freq_test | tr "-" " "
			fi

			if [ $freq_test -lt $freq ]; then
				freq=$freq_test
				nn=$m
				decoded_str=$string
			fi
		done		
	fi

	echo -ne "\nPlain text (ROT-$nn) : "
	echo -e "$decoded_str\n" | tr "-" " "


elif [[ $1 == *-e* && $# -ge 2 ]]; then

	arg=`echo $Encode_str | tr " " "-"`
	
	if (( $first )); then

		encoded_str=`encode $arg $first`
		nn=$first
		
	else
		encoded_str=`encode $arg 13`
		nn=13
	fi
	echo -ne "\nCipher text (ROT-$nn) : "
	echo -e "$encoded_str\n" | tr "-" " "

elif [[ $1 == *-h* ]]; then
	display_help
else
	echo -e "\nUsage : ./rotcrypt.sh <Rotation number> [Options] <String>\n"

fi
