lamda = 1;
delete('optimalVsHeuristic.dat');

l = [0.01,0.025,0.05,0.075,0.1,0.25,0.5,0.75,1,1.5,2,3,4,5];

[row1,col1] = size(l);
energy = fopen('optimalVsHeuristic.dat','at');

while lamda<= col1

filename = sprintf('%s%f%s','EMMA_l',l(lamda),'.txt');
energypar = fopen(filename,'r');
filename = sprintf('%s%f%s','OPTIMAL_l',l(lamda),'.txt');
energypar1 = fopen(filename,'r');
energymatrix = fscanf(energypar,'%f %f',[2 Inf]);
energymatrix = energymatrix';
[row,col] = size(energymatrix);

Totalenergy = 0;
for i = 1:1:row-1
   Totalenergy =  energymatrix(i,2)*(energymatrix(i+1,1)-energymatrix(i,1))+Totalenergy;
end

Totalenergy = Totalenergy/energymatrix(row,1);


energymatrix = fscanf(energypar1,'%f %f',[2 Inf]);
energymatrix = energymatrix';
[row,col] = size(energymatrix);

Totalenergy1 = 0;
for i = 1:1:row-1
   Totalenergy1 =  energymatrix(i,2)*(energymatrix(i+1,1)-energymatrix(i,1))+Totalenergy1;
end

Totalenergy1 = Totalenergy1/energymatrix(row,1);


fprintf(energy,'%d\t%f\t%f\n',l(lamda),Totalenergy1/(l(lamda)*500),Totalenergy/(l(lamda)*500));

lamda = lamda +1;
end


 