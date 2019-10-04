loop = 1;
avg = fopen('Emma','w');
filename = sprintf('%s%d%s','EmmaVsNopowerSaving',loop,'.dat');
energy = fopen(filename,'r');
energymatrix = fscanf(energy,'%f %f',[2 Inf])
loop = loop + 1;
while loop <= 10
    filename = sprintf('%s%d%s','EmmaVsNopowerSaving',loop,'.dat');
    energy = fopen(filename,'r');
    energymatrix = energymatrix + fscanf(energy,'%f %f',[2 Inf]);
    loop = loop + 1;
end
averageEnergy = energymatrix/10;
loop = 1;
while loop <= 10
    fprintf(avg,'%d',averageEnergy(loop,1));
    loop = loop + 1;
end
