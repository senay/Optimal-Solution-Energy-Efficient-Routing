powertime = fopen('powertime.txt','r');
power     = fopen('../../../poweropt.txt','r');
output    = fopen('powertime_opt.txt','w');
lamda     = 0.01;
%inputdata = fscanf(input,'%s %s',[2 Inf]);
while ~feof(power)
    tline = fgets(power);
    if tline(1,1) == 't'
       tempstrig = strsplit(tline);
       tline = char(tempstrig(1,3));
       tlinetime = fgets(powertime);
        tempstrig = strsplit(tlinetime);
        tlinetime = char(tempstrig(1,1));
       fprintf(output,'%s\t%s \n',tlinetime,tline); 
    end
end

movefile( 'EMMA.txt',sprintf('%s%f%s','EMMA_l',lamda,'.txt'));
movefile( 'powertime_opt.txt' ,sprintf('%s%f%s','OPTIMAL_l',lamda,'.txt'));

delete('../../../poweropt.txt');



