energypar = fopen('1.txt','r');
energymatrix = fscanf(energypar,'%f %f',[2 Inf]);
energymatrix = energymatrix';
[row,col] = size(energymatrix);

Totalenergy = 0;
for i = 1:1:row-1
   Totalenergy =  energymatrix(i,2)*(energymatrix(i+1,1)-energymatrix(i,1))+Totalenergy;
end

Totalenergy = Totalenergy/energymatrix(row,1);

energy = fopen('totalenergy.txt','w');
fprintf(energy,'%f\n',Totalenergy);



 