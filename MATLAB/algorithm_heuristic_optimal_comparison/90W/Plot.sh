#!/bin/bash
gnuplot <<- EOF
#################################################################################################
reset
set terminal png size 800,600
set output "varying_lambda_simulation.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:3]
set ytics 0,1,3
set xrange [1:5]
set xtics 1,1,5
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "1.dat" using 1:2 title 'EMMA_SIMULATION' with linespoints ls 1,\
     "2.dat" using 1:2 title 'NO_POWER_SAVING_SIMULATION' with linespoints ls 2  
##################################################################################################        
reset
set terminal png size 800,600
set output "varying_nodes_simulation.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:2]
set ytics 0,1,2
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 11 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5   # --- blue

set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "blue" lt 1 lw 1.5 pt 5 ps 1.5  
set style line 3 lc rgb "blue" lt 1 lw 1.5 pt 3 ps 1.5  
show grid
plot "3.dat" using 1:2 title 'Flow Arrival Rate = 2' with linespoints ls 1,\
     "4.dat" using 1:2 title 'Flow Arrival Rate = 3' with linespoints ls 2,\
     "5.dat" using 1:2 title 'Flow Arrival Rate = 4' with linespoints ls 3
#################################################################################################
reset
set terminal png size 800,600
set output "varying_nodes_comparison_sumulation.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:2]
set ytics 0,1,2
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "4.dat" using 1:2 title 'EMMA_SIMULATION' with linespoints ls 1,\
     "6.dat" using 1:2 title 'NO_POWER_SAVING_SIMULATION' with linespoints ls 2
#################################################################################################
EOF
