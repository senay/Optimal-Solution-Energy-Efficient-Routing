#!/bin/bash

gnuplot <<- EOF
reset
set terminal png size 800,600
set output "power.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow Arrival Rate [#Flows/S]"
set ylabel "Average Power Per Flow[W]"
set yrange [0:9]
set ytics 0,1,9
set xrange [1:5]
set xtics 1,1,5
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
show grid
plot "varying_rate.dat" using 1:2 title 'Average Power' with linespoints      
EOF
