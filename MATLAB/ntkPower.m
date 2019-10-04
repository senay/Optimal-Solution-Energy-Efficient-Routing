function ntkPower(uData, n, lambda)

load = uData.load;
numberActiveFlows = uData.numberActiveFlows;

eTCAMsearch = 7.141493;  %TCAM search energy in nJ
eDatard = 0.387645;      % energy required to read data 
eTCAMwt = 0.931197;      %energy required to write to TCAM
eDatawt = 0.365080;      %eenergy required to write data
p = 0.1;                 %probability that a flow-key is found in the TCAM

%TCAM lookup energy is given by
eLookup = eTCAMsearch + p*eDatard + (1-p)*eTCAMwt + eDatawt;

pktSize = 64;          %flow rate in number of packets per second
eMac = 97;             % MAC energy required for 64byte packet
eBufwt = 4.4993;       %buffer write energy in nJ

%energy of reception is given by
eRx = pktSize*(eMac + eBufwt);

pIdle = 200;           % idle ppower of a node in watts

eBufrd = 4.5048;       %buffer read energy for 64 byte packet in nJ
eFab = 96;  %energy required to ransfer the packet accros the fabric to the output port

%energy required to read he packet from theinput buffer transfer accross
%the fabric and write it to the output buffer
eXfer = pktSize*(eBufrd + eFab + eBufwt);

%energy required for the transmission of the packet
eTx = pktSize*(eMac + eBufrd);

Ep = eLookup; %packet processing energy
Esf = eRx + eXfer + eTx; %packet store and forward energy

    ntkPwr = 0; %initialize total network power
    %compute the energy rate in the network at a given instant of time
    for i = 1:n
        if(any(load(i,:)))
            ntkPwr = ntkPwr + pIdle;
            for j = 1:n
                if(load(i,j)>0)
                    ntkPwr = ntkPwr + load(i,j)*(10.^3)*(Ep +pktSize*Esf)/(10.^9);
                end
            end
        end
    end
    %write the flow arrival rate the power and the number of flows to a file 
    avgPwr = ntkPwr/numberActiveFlows;
    fp = fopen('Energy .txt','at');
    fprintf(fp, '%f\t %f\t %d\t %f\n', lambda, ntkPwr, numberActiveFlows, avgPwr);
    fclose(fp);
end