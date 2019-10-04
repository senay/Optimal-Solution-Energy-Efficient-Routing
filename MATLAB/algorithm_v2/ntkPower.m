function [ntkPwr, powerConsumption] = ntkPower(uData, N)

load = uData.load;

eTCAMsearch = 7.141493;  %TCAM search energy in nJ
eDatard = 0.387645;      %reading the forwarding instruction data RAMs 
eTCAMwt = 0.931197;      %energy required to write to TCAM
eDatawt = 0.365080;      %updating the forwarding instruction RAMs
p = 0.1;                 %probability that a flow-key is found in the TCAM

%TCAM lookup energy is given by
eLookup = eTCAMsearch + p*eDatard + (1-p)*eTCAMwt + eDatawt;

pktSize = 64;          %packet size
eMac = 97;             % MAC energy required for 64byte packet
eBufwt = 4.4993;       %buffer write energy in nJ for 64byte packet

%energy of reception is given by
eRx = (pktSize/64)*(eMac + eBufwt);% divide packet size by 64 since the energy values of 
                                   %parameters is given for 64 byte packet

pIdle = 90;           % idle power of a node in watts

eBufrd = 4.5048;       %buffer read energy for 64 byte packet in nJ
eFab = 96;             %energy required to ransfer the packet accros the fabric to the output port per 64 byte packet

%energy required to read the packet from theinput buffer transfer accross
%the fabric and write it to the output buffer
eXfer = (pktSize/64)*(eBufrd + eFab + eBufwt);% divide packet size by 64 since the energy values of
                                              % parameters is given for 64 byte packet

%energy required for the transmission of the packet
eTx = (pktSize/64)*(eMac + eBufrd);% divide packet size by 64 since the energy values of 
                                   % parameters is given for 64 byte packet

Ep = eLookup; %packet processing energy
Esf = eRx + eXfer + eTx; %packet store and forward energy
powerConsumption(1:N) = 0;  %power consumption of nodes as a funtion of their loaad

    ntkPwr = 0; %initialize total network power
    %compute the energy rate in the network at a given instant of time
    for i = 1:N
        if(any(load(i,:)))% if the node has at least one link
            ntkPwr = ntkPwr + pIdle;
            powerConsumption(i) = pIdle;
            for j = 1:N
                if(load(i,j)>0)
                    ntkPwr = ntkPwr + load(i,j)*(Ep + Esf)/(10.^9);
                    powerConsumption(i) = powerConsumption(i) + load(i,j)*(10.^3)*(Ep + Esf)/(10.^9);
                end
            end
        end
    end
   
end
