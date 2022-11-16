#!/bin/bash

#sed -e only to view the preview of 
#to effectively modify the file put -i before -e

#sed  -e "s/,//g" data.csv


#Here the “s” specifies the substitution operation. The “/” are delimiters. The “,” is the search pattern and the “” is the replacement string.

#By default, the sed command replaces the first occurrence of the pattern in each line and it won’t replace the second, third…occurrence in the line.
#Replacing all the occurrence of the pattern in a line : The substitute flag /g (global replacement) specifies the sed command to replace all the occurrences of the string in the line.
#see link
#https://www.geeksforgeeks.org/sed-command-in-linux-unix-with-examples/



#sed '1,4d' data.csv
#delete rows from 1 to 4

#multicommand syntax
#https://www.gnu.org/software/sed/manual/html_node/Multiple-commands-syntax.html

#sed -e '1,4d' -e "s/,//g" data.csv


#to delete the lines starting with #
#sed -e '/^#/d' data.csv

sed -e '/^#/d' -e "s/,//g" data.csv >data.txt



#note some numbers are decimals ending with .0, we just want to remove them
#to let sed find the dot it is necessary to use a slash \. in this case \.0
sed -e 's/\.0//g' data.txt | grep -E -i -o '(^| )?[0-9]?[02468]( |$)'|wc -l

#grep -E -i -o '(^| )1?[0-9]?[02468]( |$)' data.txt |wc -l

#https://www.tecmint.com/count-word-occurrences-in-linux-text-file/
#grep -c alone will count the number of lines that contain the matching word instead of the number of total matches
#The -o option is what tells grep to output each match in a unique line and then wc -l tells wc to count the number of lines. 

#https://askubuntu.com/questions/891493/separating-even-and-odd-numbers
# about (^| )?[0-9]?[02468]( |$)
#first choice: 1st character can be ^= start of the line, OR a space
#?matches the previous token between zero and one times, as many times as possible, giving back as needed (greedy)
#[0-9] character between 0 and 9
#[02468] single characters that is even
echo "#Even numbers: $(sed -e  's/\.0//g' data.txt | grep -E -i -o '(^| )?[0-9]?[02468]( |$)'|wc -l)"
echo "#Odd numbers: $(sed -e 's/\.0//g' data.txt | grep -E -i -o '(^| )?[0-9]?[13579]( |$)'|wc -l)"
sed -e 's/\.0//g' data.txt | grep -E -i -o '(^| )?[0-9]?[02468]( |$)'|wc -l
sed -e 's/\.0//g' data.txt | grep -E -i -o '(^| )?[0-9]?[13579]( |$)'|wc -l




 nline=$(wc -l < data.txt)
# echo "# of lines:$nline"

 threshold=$(echo "100*sqrt(3)/2" | bc -l)
# echo "threshold:$threshold"




# Distinguish the entries on the basis of sqrt(X^2 + Y^2 + Z^2) is greater or smaller than 100*sqrt(3)/2. Count the entries of each of the two groups

 line=1
 while [ $line -le $nline ]
 do
 	x=$(sed -n "$line,$line p" data.txt|cut -f1 -d " ")
	y=$(sed -n "$line,$line p" data.txt|cut -f2 -d " ")
	z=$(sed -n "$line,$line p" data.txt|cut -f3 -d " ")
	#echo "x:$x, y:$y, z:$z"
	
	eval=$( echo "sqrt($x*$x+$y*$y+$z*$z)" | bc -l)  #here the comparison must be done via BC because bash can compare only integers
	#echo "eval:$eval"
	
	 if (( $(echo "$eval >= $threshold" | bc -l) ));
   		then sed -n "$line,$line p" data.txt >>greater.txt;
   		else sed -n "$line,$line p" data.txt >>smaller.txt;   	
 	 fi
 	 
 	 line=$(($line+1))
 	 
 done


# Make n copies of data.txt (with n an input parameter of the script), where the i-th copy has all the numbers divided by i (with 1<=i<=n).

ncopies=$1 #$1 stands for the 1st parameter in input while executing the code: ./script_Ex03_pt2.sh 6,  in this case $1==6
i=1
while [ $i -le $ncopies ]
do

	filename="copy$i.txt"
	
	#You pass an external variable for use in awk with the -v option:
	#-F field separator input file,  OFS field separator output file
	#-v passing an external variable
	LC_ALL=en awk -F' ' -v OFS=' ' -v k=$i  '{for(i=1;i<=NF;i++){ $i=$i*1./k} print $0}' data.txt >>$filename
	#LC all to use the dot as decimal separator, set the languange regional convention
	
	#echo "copy: $i">>$filename
	i=$(($i+1))
done














