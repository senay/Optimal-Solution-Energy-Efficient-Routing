clear all;
%filename = sprintf('%s%s','GAIN_ENERGY_200','.dat');
%filename = sprintf('%s%s','GAIN_ENERGY_N3_90','.dat');
%filename = sprintf('%s%s','GAIN_ENERGY_90','.dat');
%filename = sprintf('%s%s','GAIN_ENERGY_N3_200','.dat');
%filename = sprintf('%s%s','GAIN_ENERGY_90_AVE','.dat');
%filename = sprintf('%s%s','GAIN_ENERGY_200_AVE','.dat');
%filename = sprintf('%s%s','GAIN_ENERGY_N2_90','.dat');
filename = sprintf('%s%s','GAIN_ENERGY_N4_90','.dat');
Power_gain = fopen(filename,'w');

   
%EMMA = fopen('energy_opt_200.dat','r');
%EMMA = fopen('N3_90.dat','r');
%EMMA = fopen('energy_opt_90_ave.dat','r');
%EMMA = fopen('energy_opt_200_ave.dat','r');
EMMA = fopen('N4_90.dat','r');
%EMMA = fopen('N3_200.dat','r');
AveVal_EMMA= fscanf(EMMA,'%f %f',[2 Inf]);   
AveVal_EMMA = AveVal_EMMA';

%NOPOWERSAVING = fopen('energy_non_opt_200.dat','r');
%NOPOWERSAVING = fopen('N3_non_opt_90.dat','r');
%NOPOWERSAVING = fopen('energy_non_opt_90_ave.dat','r');
%NOPOWERSAVING = fopen('N2_non_opt_90.dat','r');
NOPOWERSAVING = fopen('N4_non_opt_90.dat','r');
%NOPOWERSAVING = fopen('energy_non_opt_200_ave.dat','r');
%NOPOWERSAVING = fopen('N3_non_opt_200.dat','r');
AveVal_NOPOWERSAVING= fscanf(NOPOWERSAVING,'%f %f',[2 Inf]); 
AveVal_NOPOWERSAVING = AveVal_NOPOWERSAVING';

[row,col] = size(AveVal_EMMA);

 for i = 1:1:row
     fprintf(Power_gain,'%f\t%f \n',AveVal_EMMA(i,1),(AveVal_NOPOWERSAVING(i,2)-AveVal_EMMA(i,2))/AveVal_NOPOWERSAVING(i,2));
 end
