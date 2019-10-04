clear all;
%filename = sprintf('%s%s','NOPOWERSAVING_AVERAGE_VARYING_NODES','.dat');
filename = sprintf('%s%s','EMMA_AVERAGE_VARYING_NODES','.dat');
EMMAAVE = fopen(filename,'w');

N=15;

for i=1:1:N
    
%filename = sprintf('%s%d%s','NOPOWERSAVING/NOPOWERSAVING_VARYING_NODES_',i,'.txt');
filename = sprintf('%s%d%s','EMMA_VARYING_NODES_',i,'.txt');
EMMA = fopen(filename,'r');
 AveVal= fscanf(EMMA,'%f %f',[2 Inf]);    
 AveVal = AveVal';
 if(i == 1)
      total(:,2) = AveVal(:,2) ;
 else
     total(:,2) = AveVal(:,2) + total(:,2);
 end
end

[row,col] = size(AveVal);

total(:,1) = AveVal(:,1);
total(:,2) = total(:,2)/N;

 for i = 1:1:row
     fprintf(EMMAAVE,'%f\t%f \n',total(i,1),total(i,2));
 end


