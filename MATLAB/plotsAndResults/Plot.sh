#!/bin/bash
gnuplot <<- \EOF

#1#################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "implementation/varying_lambda_emulation_gain_90.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow arrival rate [#flows/s]"
set ylabel "Average Power Per Flow [W]"
set yrange [0:1]
set ytics 0,0.1,1
set xrange [0.01:3]
set logscale x
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "GAIN_ENERGY_90.dat" using 1:2 title 'Gain in power consumption per flow' with linespoints ls 1

#2#################################################################################################


reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "implementation/varying_lambda_emulation_90.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow arrival rate [#flows/s]"
set ylabel "Average Power Per Flow [W]"
set yrange [0:200]
set ytics 0,10,200
set xrange [0.01:5]
set logscale x
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "energy_opt_90.dat" using 1:2 title 'EMMA - Emulation' with linespoints ls 1,\
     "energy_non_opt_90.dat" using 1:2 title 'No Power Saving - Emulation' with linespoints ls 2  
##################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "implementation/varying_nodes_emulation_90.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:2]
set ytics 0,0.5,2
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 11 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5   # --- blue

set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "blue" lt 1 lw 1.5 pt 5 ps 1.5  
set style line 3 lc rgb "blue" lt 1 lw 1.5 pt 3 ps 1.5  
show grid
plot "N2_90.dat" using 1:2 title 'Flow Arrival Rate = 2' with linespoints ls 1,\
     "N3_90.dat" using 1:2 title 'Flow Arrival Rate = 3' with linespoints ls 2,\
     "N4_90.dat" using 1:2 title 'Flow Arrival Rate = 4' with linespoints ls 3

#3################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "implementation/varying_nodes_comparison_emulation_90.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Gain in Average Power Per Flow"
set yrange [0:3]
set ytics 0,0.5,3
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
#plot "implementation/varying_nodes_gain.dat" using 1:2 title 'Power Consumption Comparison' with linespoints ls 1
plot "N3_90.dat" using 1:2 title 'EMMA - Emulation' with linespoints ls 1,\
     "N3_non_opt_90.dat" using 1:2 title 'No Power Saving - Emulation' with linespoints ls 2
#4################################################################################################

reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "implementation/varying_nodes_comparison_emulation_90_gain.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Gain Average Power Per Flow"
set yrange [0:0.6]
set ytics 0,0.1,0.6
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "GAIN_ENERGY_N3_90.dat" using 1:2 title 'Power Consumption Comparison' with linespoints ls 1
#4################################################################################################


reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation200W/varying_lambda_simulation.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow arrival rate [#flows/s]"
set ylabel "Average Power Per Flow [W]"
set yrange [0:6]
set ytics 0,1,6
set xrange [1:5]
set xtics 1,1,5
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "simulation200W/EmmaVsNopowerSaving.dat" using 1:2 title 'EMMA - Simulation' with linespoints ls 1,\
     "simulation200W/EmmaVsNopowerSaving.dat" using 1:3 title 'No Power Saving - Simulation' with linespoints ls 2  
#5#################################################################################################        
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation200W/varying_nodes_simulation.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:4]
set ytics 0,1,4
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 11 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5   # --- blue

set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "blue" lt 1 lw 1.5 pt 5 ps 1.5  
set style line 3 lc rgb "blue" lt 1 lw 1.5 pt 3 ps 1.5  
show grid
plot "simulation200W/N2.dat" using 1:2 title 'Flow Arrival Rate = 2' with linespoints ls 1,\
     "simulation200W/N3.dat" using 1:2 title 'Flow Arrival Rate = 3' with linespoints ls 2,\
     "simulation200W/N4.dat" using 1:2 title 'Flow Arrival Rate = 4' with linespoints ls 3
#6################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation200W/varying_rate_simulation.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow Arrival Rate [#flows/s]"
set ylabel "Average Power Per Flow [W]"
set yrange [0:9]
set ytics 0,1,9
set xrange [1:5]
set xtics 1,1,5
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
show grid
plot "simulation200W/varying_rate.dat" using 1:2 title 'Average Power' with linespoints ls 1
#7################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation200W/varying_nodes_comparison_simulation.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:3]
set ytics 0,1,3
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "simulation200W/N3.dat" using 1:2 title 'EMMA - Simulation' with linespoints ls 1,\
     "simulation200W/N3_non_opt.dat" using 1:2 title 'No Power Saving - Simulation' with linespoints ls 2
#################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation200W/varying_flow_duration_simulation.png"
set size 0.8,1
set style line lt 6 lw 6 pt 7 ps 10
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
plot "simulation200W/varying_mu_opt.dat" using 1:2 title 'EMMA - Simulation' with linespoints ls 1,\
     "simulation200W/varying_mu_non_opt.dat" using 1:2 title 'No Power Saving - Simulation' with linespoints ls 2
#################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "optimization/heuristic_opt_comp.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow arrival rate [#flows/s]"
set ylabel "Average Power Per Flow [W]"
set yrange [0:20]
set ytics 0,10,60
set xrange [0.01:5]
set logscale x
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "optimization/optimalVsHeuristic.dat" using 1:3 title 'EMMA' with linespoints ls 1,\
     "optimization/optimalVsHeuristic.dat" using 1:2 title 'Optimal Solution' with linespoints ls 2  
##################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation90W/varying_lambad_90.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow arrival rate [#flows/s]"
set ylabel "Average Power Per Flow [W]"
set yrange [0:200]
set ytics 0,10,200
set xrange [0.01:5]
set logscale x
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "simulation90W/varying_lambda/EMMA_AVERAGE.dat" using 1:2 title 'EMMA' with linespoints ls 1,\
     "simulation90W/varying_lambda/NOPOWERSAVING_AVERAGE.dat" using 1:2 title 'Optimal Solution' with linespoints ls 2  
##################################################################################################
reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation90W/varying_lambad_90_gain.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Flow arrival rate [#flows/s]"
set ylabel "Average Power Per Flow [W]"
set yrange [0:1]
set ytics 0,0.1,1
set xrange [0.01:5]
set logscale x
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "simulation90W/varying_lambda/GAIN.dat" title "Gain in Average Power Per Flow" using 1:2  with linespoints ls 1
   
##################################################################################################

reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation90W/varying_nodes_simulation_90.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:3]
set ytics 0,0.5,3
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 11 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.5   # --- blue

set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "blue" lt 1 lw 1.5 pt 5 ps 1.5  
set style line 3 lc rgb "blue" lt 1 lw 1.5 pt 3 ps 1.5  
show grid
plot "simulation90W/varying_nodes/l2/EMMA_AVERAGE_VARYING_NODES.dat" using 1:2 title 'Flow Arrival Rate = 2' with linespoints ls 1,\
     "simulation90W/varying_nodes/l3/EMMA_AVERAGE_VARYING_NODES.dat" using 1:2 title 'Flow Arrival Rate = 3' with linespoints ls 2,\
     "simulation90W/varying_nodes/l4/EMMA_AVERAGE_VARYING_NODES.dat" using 1:2 title 'Flow Arrival Rate = 4' with linespoints ls 3
#################################################################################################

reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation90W/varying_nodes_comparison_sumulation_90.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:50]
set ytics 0,10,50
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "simulation90W/varying_nodes/l0.1/EMMA_AVERAGE_VARYING_NODES.dat" using 1:2 title 'EMMA - Simulation' with linespoints ls 1,\
     "simulation90W/varying_nodes/l0.1/NOPOWERSAVING_AVERAGE_VARYING_NODES.dat" using 1:2 title 'No Power Saving - Simulation' with linespoints ls 2
#################################################################################################

reset
set terminal png font "/usr/share/fonts/truetype/msttcorefonts/Times_New_Roman.ttf" 11 size 800,600
set output "simulation90W/varying_nodes_comparison_sumulation_90_gain.png"
set size 0.8,1
set style line 1 lt 6 lw 6 pt 7 ps 10
set style data linespoints
set xlabel "Number of Nodes"
set ylabel "Average Power Per Flow [W]"
set yrange [0:1]
set ytics 0,0.1,1
set xrange [5:25]
set xtics 5,5,25
set grid ytics lt 0 lw 1 lc rgb "#bbbbbb"
set style line 1 lc rgb "blue" lt 1 lw 1.5 pt 7 ps 1.5  
set style line 2 lc rgb "red" lt 1 lw 1.5 pt 5 ps 1.5
show grid
plot "simulation90W/varying_nodes/l0.1/GAIN.dat" title "Gain in Average Power Per Flow" using 1:2 with linespoints ls 1
#################################################################################################

EOF
