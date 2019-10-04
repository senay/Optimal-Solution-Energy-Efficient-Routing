amplrun = fopen('amplrun.txt','w');

for i=1:1:10000
    
  fprintf(amplrun,'%s%d%s\n','reset data;data routdata',i,'.dat;solve;');
  fprintf(amplrun,'%s\n\n','display total_power > poweropt.txt;');
    
end
