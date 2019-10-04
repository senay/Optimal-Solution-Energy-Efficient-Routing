loop = 1;
while loop <= 15


l = [0.01,0.025,0.05,0.075,0.1,0.25,0.5,0.75,1,1.5,2,3,4,5];

[row1,col1] = size(l);
%lamda = 1;


N = 0;                          %number of nodes

while N < 5
    N = N + 5;
delete('Demand.txt');
delete('EMMA.txt');

maxPower = 230;                  %maximum power that a node should consume
demand(1:N, 1:N) = 0;
activeLinks(1:N, 1:N) = 0;       %current active network
powerConsumption(1:N) = 0;       %power consumption of nodes as a funtion of their loaad
NN = N;
load(1:N, 1:N) = 0;             %load on the current active network
size(load);
available(1:N, 1:N) = 0;         %links available on the entire network for routing carying 
                                %additional traffic with a given flow rate 
availableActive(1:N, 1:N) = 0;     %links available on the active network for routing carying 
                                 %additional traffic with a given flow rate 
shPath = zeros(1,N);            %shortest path to be selected for a flow
flowRouted = 0;                  % indicates if a flow has been assigned a path successfully
numberActiveFlows = 0;           % number of active flows
currentFlowNumber = 0;           % the last flow number

flowRate = 2000;                    % data rate of a flow in the order of K packets/s

mu = 20;                         % mean duration of a flow
lambda = 1;                      % flow arrival rate,
simulationTime = 500;            %simulation time in seconds
s = randi(N,1,1);               %source node


%bring s link up between any two nodes with probability 0.5 and indicate
%its availability for carrying traffic
A = rand(N);% create random N by N matrix
B = triu(A > 0.5,1);%create upper triangular matrix with 0.5 probability of 1
C = B + B'; %create a symmetric matrix of ones and zeros 

Capacity = 20000*C; % 20*packetSize is the capacity
     
%Initialize flow structure
flows = repmat(struct('source', 0, 'sink', 0, 'startTime', 0, 'endTime', 0,'shPath',shPath, 'flowId', 0, 'flowRate', 0),1000,1);
networkPower = repmat(struct('power',0,'timeInterval',0),2000,1);
%Prepare UserData to use between timer callback functions
uData = struct('source', s, 'activeLinks', activeLinks, 'load', load, 'flows', flows, 'numberActiveFlows', numberActiveFlows, 'capacity', Capacity,'currentFlowNumber', currentFlowNumber,'demand',demand);

currentTime = 0; %time since the simulation started

arrivalTimeLast = 0; %last flow arrival time
arrivalTimeNow = 0;  %the current flow start time

eventTimetLast = 0;  % last time an event occurred
eventTimeNow = 0;    % the time at which the current event occured
eventsCount = 0;      % number of events that has already occured
totalEnergy = 0;
ntkPwrN = 0;
ntkPwrP = 0;
pff = fopen('EMMA.txt','w');
while(currentTime < simulationTime),
    
    %flowRate = randi([2,10]); %choose a random integer between 1 and 10 for the flowRate 
    
    load = uData.load;
    flows = uData.flows;
    activeLinks = uData.activeLinks;
    
    %select links that are able to carry an additional flow with a given
    %data rate both on the active network and on the entire network
    available = triu((Capacity - load -flowRate)>0, -N);
    availableActive = available.*activeLinks;
    
    %select nodes that have not exceeded their power consumption limit    
    for i = 1:N
        if (any(availableActive(i,:))&&(powerConsumption(i) > maxPower))
            for j = 1:N
                available(i,j) = 0;
                available(j,i) = 0;
                availableActive(i,j) = 0;
                availableActive(j,i) = 0;
            end
        end
    end
    
    
    startDelay = exprnd(1/lambda);      % time to the start of the next flow
    currentTime = currentTime + startDelay; % starting time of the flow
    arrivalTimeLast = arrivalTimeNow;   % update the the last arrival time
    arrivalTimeNow = currentTime;         % update the current arival time
    
    % select all flows that end before the next arrival time of a flow
    endingFlows = flows(arrayfun(@(x) all(x.endTime > arrivalTimeLast) & all(x.endTime <= arrivalTimeNow), flows));
    if(~isempty(endingFlows))
        %first sort the elements by the endtime field
            flowsCell = struct2cell(endingFlows);
            sz = size(flowsCell);
            % Convert to a matrix
            flowsCell = reshape(flowsCell, sz(1), []);      % Px(MxN)
            % Make each field a column
            flowsCell = flowsCell';                         % (MxN)xP
            % Sort by fourth field "endTime"
            flowsCell = sortrows(flowsCell, 4);
        endingFlowsQuantity = length(endingFlows);
        %change back a structure array
        endingFlows = cell2struct(flowsCell,{'source', 'sink', 'startTime', 'endTime','shPath', 'flowId', 'flowRate'},2);
        %handle finishing of ending of flows that end before the next flow
        %arrival time
        for i = 1:endingFlowsQuantity
            eventTimeLast = eventTimeNow;
            eventTimeNow = endingFlows(i).endTime;
            % schedule the flow finish time call flowFinishTimer.m
            flowFinish(endingFlows(i).flowId, eventTimeNow,N);
            
            [ntkPwr, powerConsumption] = ntkPower(uData, N);
            
            eventsCount = eventsCount + 1;
            ntkPwrP=ntkPwrN;
            ntkPwrN=ntkPwr;
            
            networkPower(eventsCount).power = ntkPwr;
            fprintf(pff, '%f  %f\n', eventTimeNow, ntkPwr);
            
        demand = uData.demand;
             pf = fopen('Demand.txt','at');
            totalDemand=0;
            for i=1:1:N
                totalDemand=totalDemand+demand(s,i);
            end
            fprintf(pf, '"%d" %d,\n',s, -totalDemand);
            
            for i=1:1:N
                totalDemand=totalDemand+demand(s,i);
                if demand(s,i) > 0
                    fprintf(pf, '"%d" %d,\n', i, demand(s,i));
                end
            end
        fprintf(pf,'%d\n',eventTimeNow);
        fclose(pf);
            
            eventTimeNow;
            networkPower(eventsCount).timeInterval = eventTimeNow - eventTimeLast;
            totalEnergy = totalEnergy + ntkPwrP*(eventTimeNow - eventTimeLast);
        end
    end
        
    % The flowArrival.m function handles an incoming flow
    flowArrival(available, availableActive, flowRate, N, currentTime, mu,eventTimeNow);
    eventTimeLast = eventTimeNow;
    eventTimeNow = currentTime;
    [ntkPwr, powerConsumption] = ntkPower(uData, N);
    fprintf(pff, '%f  %f\n', eventTimeNow, ntkPwr);
    
    demand = uData.demand;
     pf = fopen('Demand.txt','at');

    totalDemand=0;
    for i=1:1:N
        totalDemand=totalDemand+demand(s,i);
    end
    fprintf(pf, '"%d" %d,\n',s, -totalDemand);

    for i=1:1:N
        totalDemand=totalDemand+demand(s,i);
        if demand(s,i) > 0
            fprintf(pf, '"%d" %d,\n', i, demand(s,i));
        end
    end
        
    fprintf(pf,'%d\n',eventTimeNow);
    fclose(pf);
    
    eventsCount = eventsCount + 1;
    networkPower(eventsCount).power = ntkPwr;
    eventTimeNow;
    ntkPwrP=ntkPwrN;
    ntkPwrN=ntkPwr;
    networkPower(eventsCount).timeInterval = eventTimeNow - eventTimeLast;
    totalEnergy = totalEnergy + ntkPwrP*(eventTimeNow - eventTimeLast);
end

% handle the finishing of all flows that are scheduled to end after the
% final flow arrival
flows = uData.flows;
endingFlows = flows(arrayfun(@(x) all(x.endTime >= arrivalTimeNow), flows));

if(~isempty(endingFlows))
    %first sort the elements by the endtime field
    %flowsFields = fieldnames(endingFlows);
    flowsCell = struct2cell(endingFlows);
    sz = size(flowsCell);
    % Convert to a matrix
    flowsCell = reshape(flowsCell, sz(1), []);      % Px(MxN)
    % Make each field a column
    flowsCell = flowsCell';                         % (MxN)xP
    % Sort by fourth field "endTime"
    flowsCell = sortrows(flowsCell, 4);
    endingFlowsQuantity = length(endingFlows);
    endingFlows = cell2struct(flowsCell,{'source','sink','startTime','endTime','shPath','flowId','flowRateRate'},2);
    for i = 1:endingFlowsQuantity
        eventTimeLast = eventTimeNow;
        eventTimeNow = endingFlows(i).endTime;
        % schedule the flow finish time call floeFinishTImer.m
        flowFinish(endingFlows(i).flowId, eventTimeNow,N);
        
        demand = uData.demand; 
        pf = fopen('Demand.txt','at');

        totalDemand=0;
        for i=1:1:N
            totalDemand=totalDemand+demand(s,i);
        end
        fprintf(pf, '"%d" %d,\n',s, -totalDemand);

        for i=1:1:N
            totalDemand=totalDemand+demand(s,i);
            if demand(s,i) > 0
                fprintf(pf, '"%d" %d,\n', i, demand(s,i));
            end
       end
        
        fprintf(pf,'%d\n',eventTimeNow);
        fclose(pf);

        [ntkPwr, powerConsumption] = ntkPower(uData, N);
        fprintf(pff, '%f  %f\n', eventTimeNow, ntkPwr);        
        eventsCount = eventsCount + 1;
        eventTimeNow;
        networkPower(eventsCount).power = ntkPwr;
        ntkPwrP=ntkPwrN;
        ntkPwrN=ntkPwr;
        networkPower(eventsCount).timeInterval = eventTimeNow - eventTimeLast;
        totalEnergy = totalEnergy + ntkPwrP*(eventTimeNow - eventTimeLast);
    end
end

averagePowerPerFlow  = (totalEnergy/eventTimeNow)/uData.currentFlowNumber;
uData.currentFlowNumber;

movefile( 'EMMA.txt',sprintf('%s%f%s','EMMA_N',N,'.txt'));
%lamda = lamda +1

end

%write the flow arrival rate and the average power per flow to a file
% fp = fopen('Energy.txt','at');
% fprintf(fp, '%d\t %f\n', lambda, averagePowerPerFlow);
% fclose(fp);
energycalc(loop);
    clear load;
    clear availableActive; 
    clear available;
    clear activeLinks;
    
    
loop = loop + 1;
end
