#!/bin/bash
cd $HOME
mkdir students
wget https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv

if [ ! -f "./students/LCP_22-23_students.csv" ]
then
cp LCP_22-23_students.csv $HOME/students
fi


cd students
touch PoD_students.csv
head -1 LCP_22-23_students.csv >PoD_students.csv
grep "PoD*" LCP_22-23_students.csv >> PoD_students.csv

touch Physics_students.csv
head -1 LCP_22-23_students.csv >Physics_students.csv
grep "Physics*" LCP_22-23_students.csv >> Physics_students.csv



echo "#Letter, Number of students with surname starting with that letter" >>counting.txt

max=0
Lmax=""

for x in {A..Z}
do
    echo -n "$x:" >>counting.txt
 #-n to avoid newline after echo

    grep -c "^$x" LCP_22-23_students.csv >>counting.txt
 #-c to count and suppress

   n=$( grep -c "^$x" LCP_22-23_students.csv)
   if ( [ $n -gt $max ]);
   then max=$n
   	Lmax="$x";
   elif ( [ $n == $max ]);
   then max=$n
   	Lmax+=",$x";
   fi

done


echo "max number of counts $Lmax: $max" >>counting.txt



ntot=$(wc -l < LCP_22-23_students.csv)
echo "tot student+1 : $ntot"
ntot=$(($ntot+1))
#module=18
#ngroups=$(echo "($ntot.+$module-1)/$module"| bc)





for y in {1..18}
do

	filename="group$y.txt"
	echo "group: $y">>$filename
	line=$(($y+1))

		while [ $line -le $ntot ]
		do
			echo $(sed -n "$line,$line p" LCP_22-23_students.csv) >>$filename
			line=$(($line+18))
		done;
		
done		








'(^| )?[0-9]?[0-9]( |$)'






