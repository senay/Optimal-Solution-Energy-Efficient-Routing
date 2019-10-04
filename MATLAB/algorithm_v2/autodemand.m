input = fopen('Demand.txt','r');
template = fopen('routingTemplate.txt','r');
%inputdata = fscanf(input,'%s %s',[2 Inf]);
i = 1;
power = fopen('powertime.txt','w');
delete('../../../routdata*.dat');
while ~feof(input)

filename = sprintf('%s%s%d%s','../../../','routdata',i,'.dat');
output = fopen(filename,'w');
frewind(template);
while ~feof(template)
    tline = fgets(template);
    fprintf(output,'%s',tline); 
end
fprintf(output,'\n'); 
 
while ~feof(input)
    tline = fgets(input);
    if tline(1,1) == '"'
       fprintf(output,'%s',tline); 
    else
        fprintf(power,'%s',tline); 
        break;
    end
end
status = fseek(output,-2,'cof');
fprintf(output,'%c',';');
fclose(output);
 
i = i+1;
end
%[row,col] = size(inputdata);

% % Totalenergy = 0;
% % for i = 1:1:row-1
% %    Totalenergy =  energymatrix(i,2)*(energymatrix(i+1,1)-energymatrix(i,1))+Totalenergy;
% % end
% % 
% % Totalenergy = Totalenergy/energymatrix(row,1);
% % 
% % energy = fopen('totalenergy.txt','w');
% % fprintf(energy,'%f\n',Totalenergy);

