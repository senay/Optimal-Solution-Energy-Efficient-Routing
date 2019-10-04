#!/bin/bash

gnuplot <<- EOF
reset
set terminal png size 800,600
set output "power.png"
set size 0.8,1
set title "Per Flow Average Power Consumption" font "Helvetica,14"
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "lambda[flows/sec]"
set ylabel "Average Power Per Flow[W]"
set yrange [0:1.2]
set ytics 0,0.1,1.1
set xrange [1:5]
set xtics 1,1,5
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
show grid
plot "energy.dat" using 1:2 title 'Average Power without Optimization' with linespoints,\
     "energy_opt.dat" using 1:2 title 'Average Power with Optimization' with linespoints       
EOF
