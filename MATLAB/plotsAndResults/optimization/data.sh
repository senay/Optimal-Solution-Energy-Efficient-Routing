#!/bin/bash

while read lambda	opt	heur
do
	echo "$lambda	$opt	$heur" >> optimal_heuristic.dat
done < total_energy_opt_heur_comp.txt


