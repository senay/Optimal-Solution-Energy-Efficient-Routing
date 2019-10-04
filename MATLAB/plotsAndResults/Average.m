clear all;

%filename = sprintf('%s%s','energy_non_opt_90_ave','.dat');
filename = sprintf('%s%s','energy_opt_90_ave','.dat');
Power_gain = fopen(filename,'w');

   
%EMMA = fopen('energy_non_opt_90.dat','r');
EMMA = fopen('energy_opt_90.dat','r');
AveVal_EMMA= fscanf(EMMA,'%f %f',[2 Inf]);   
AveVal_EMMA = AveVal_EMMA';


%NOPOWERSAVING = fopen('energy_non_opt_90_new.dat','r');
NOPOWERSAVING = fopen('energy_opt_90_new.dat','r');
AveVal_NOPOWERSAVING= fscanf(NOPOWERSAVING,'%f %f',[2 Inf]); 
AveVal_NOPOWERSAVING = AveVal_NOPOWERSAVING';

[row,col] = size(AveVal_EMMA);

 for i = 1:1:row
     fprintf(Power_gain,'%f\t%f \n',AveVal_EMMA(i,1),(AveVal_NOPOWERSAVING(i,2)+AveVal_EMMA(i,2))/2);
 end
