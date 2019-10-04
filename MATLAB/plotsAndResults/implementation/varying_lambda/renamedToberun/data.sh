#!/bin/bash
nodePower=200
simulationTime=500
for i in 0.01 0.025 0.05 0.075 0.1 0.25 0.5 0.75 1 1.5 2 3 4 5
do
	timeP=0
	timeN=0
	tot=0
	init=0
	RESULT=0
	counter=0
	flowConter=0
	totalEnergy=0
	while read power	time
	do	
		RESULT=$(echo "$power/$nodePower" | bc -l)
		int=${RESULT%.*}
		ninety=$(($int*90))
		twoHundred=$(($int*200))
		power=`echo $power - $twoHundred | bc`
		power=`echo $power + $ninety | bc`
		
		if [ $timeN -eq $init ]
		then
			timeP=$time
			timeN=$time
			counter=1
		else		
			timeP=$timeN
			timeN=$time
			counter=$(($counter+1))
		fi
		if [ $timeP -eq $timeN ]
		then
			tot=`echo $tot + $power | bc`
		else		 		
			RESULT=$(echo "$tot/$counter" | bc -l)
			timeDif=`expr $timeN - $timeP`
			RESULT=$(echo "$RESULT*$timeDif" | bc -l)
			totalEnergy=`echo $totalEnergy + $RESULT | bc`
			counter=0
			tot=0
		fi
	done < $i.'txt'
	flowCounter=$(expr $i*500 | bc)
	RESULT=$(echo "$totalEnergy/$flowCounter" | bc -l)
	RESULT=$(echo "$RESULT/$simulationTime" | bc -l)
	echo $flowCounter
	echo "$i	$RESULT" >> ../../../energy_opt_90_new.dat
done

for i in 0.01 0.025 0.05 0.075 0.1 0.25 0.5 0.75 1 1.5 2 3 4 5
do
	timeP=0
	timeN=0
	tot=0
	init=0
	RESULT=0
	counter=0
	flowConter=0
	totalEnergy=0
	while read power	time
	do	
			
		if [ $timeN -eq $init ]
		then
			timeP=$time
			timeN=$time
			counter=1
		else		
			timeP=$timeN
			timeN=$time
			counter=$(($counter+1))
		fi
		if [ $timeP -eq $timeN ]
		then
			tot=`echo $tot + $power | bc`
		else		 		
			RESULT=$(echo "$tot/$counter" | bc -l)
			timeDif=`expr $timeN - $timeP`
			RESULT=$(echo "$RESULT*$timeDif" | bc -l)
			totalEnergy=`echo $totalEnergy + $RESULT | bc`
			counter=0
			tot=0
		fi
	done < $i.'txt'
	flowCounter=$(expr $i*500 | bc)
	RESULT=$(echo "$totalEnergy/$flowCounter" | bc -l)
	RESULT=$(echo "$RESULT/$simulationTime" | bc -l)
	echo $flowCounter
	echo "$i	$RESULT" >> ../../../energy_opt_200_new.dat
done
