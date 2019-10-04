filename = sprintf('%s%s','GAIN0.05','.dat');
Power_gain = fopen(filename,'w');

   
EMMA = fopen('N0.05_90.dat','r');
AveVal_EMMA= fscanf(EMMA,'%f %f',[2 Inf]);   
AveVal_EMMA = AveVal_EMMA';

NOPOWERSAVING = fopen('N0.05_non_opt_90.dat','r');
AveVal_NOPOWERSAVING= fscanf(NOPOWERSAVING,'%f %f',[2 Inf]); 
AveVal_NOPOWERSAVING = AveVal_NOPOWERSAVING';

[row,col] = size(AveVal_EMMA);

 for i = 1:1:row
     (AveVal_NOPOWERSAVING(i,2)-AveVal_EMMA(i,2))
     (AveVal_NOPOWERSAVING(i,2)-AveVal_EMMA(i,2))/AveVal_NOPOWERSAVING(i,2)
     fprintf(Power_gain,'%f\t%f \n',AveVal_EMMA(i,1),(AveVal_NOPOWERSAVING(i,2)-AveVal_EMMA(i,2))/AveVal_NOPOWERSAVING(i,2));
 end
