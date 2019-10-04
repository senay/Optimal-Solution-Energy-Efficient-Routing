function genLinkMatrix(Capacity,N,filename)

output = fopen(filename,'w');

fprintf(output,'%s','set Nodes :='); 
for i=1:1:N-1
    fprintf(output,'%s%d%s','"',i,'",'); 
end
    fprintf(output,'%s%d%s\n','"',i+1,'";'); 
    
    
fprintf(output,'\n%s\n','set Links :='); 

firstime = 1;
for i=1:1:N
    for j=1:1:N
        if(Capacity(i,j) > 0)
            if firstime == 1
              fprintf(output,'%s%d%s%d%s','("',i,'", "',j,'")'); 
            else
              fprintf(output,'%s%d%s%d%s',',("',i,'", "',j,'")'); 
            end
            firstime = 0;
        end
    end
     fprintf(output,'\n'); 
end
     fprintf(output,'%c',';'); 

fprintf(output,'\n%s\n','param demand :='); 

end