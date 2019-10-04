filename = sprintf('%s%s','GAIN','.dat');
Power_gain = fopen(filename,'w');

   
EMMA = fopen('EMMA_AVERAGE.dat','r');
AveVal_EMMA= fscanf(EMMA,'%f %f',[2 Inf]);   
AveVal_EMMA = AveVal_EMMA';

NOPOWERSAVING = fopen('NOPOWERSAVING_AVERAGE.dat','r');
AveVal_NOPOWERSAVING= fscanf(NOPOWERSAVING,'%f %f',[2 Inf]); 
AveVal_NOPOWERSAVING = AveVal_NOPOWERSAVING';

[row,col] = size(AveVal_EMMA);

 for i = 1:1:row
     fprintf(Power_gain,'%f\t%f \n',AveVal_EMMA(i,1),(AveVal_NOPOWERSAVING(i,2)-AveVal_EMMA(i,2))/AveVal_NOPOWERSAVING(i,2));
 end
