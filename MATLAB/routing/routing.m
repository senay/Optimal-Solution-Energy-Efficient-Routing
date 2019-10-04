N = 13;                          %number of nodes
%Capacity(1:N, 1:N) = 0;          %bandwidth of links
activeLinks(1:N, 1:N) = 0;           %current active network
load(1:N, 1:N) = 0;              %load on the current active network
available(1:N, 1:N) = 0;         %links available on the entire network for routing carying 
                                 %additional traffic with a given flow rate 
availableActive(1:N, 1:N) = 0;     %links available on the active network for routing carying 
                                 %additional traffic with a given flow rate 
shPath = zeros(1,13);            %shortest path to be selected for a flow
flowRouted = 0;                  % indicates if a flow has been assigned a path successfully
secondsInADay = 24 * 3600;       % number of seconds in a day
numberActiveFlows = 0;           % number of active flows
currentFlowNumber = 0;           % the last flow number

flowRate = 2;                    % packet arrival rate of a flow in the order of K(1000)
startingTime = now*secondsInADay;%simulation starting time

mu = 20;                         % mean duration of a flow
lambda = 5;                      % flow arrival rate,
simulationTime = 500;            %simulation time in seconds

%bring s link up between any two nodes with probability 0.5 and indicate
%its availability for carrying traffic
A = rand(N);% create random N by N matrix
B = triu(A > 0.5,1);%create upper triangular matrix with 0.5 probability of 1
C = B + B'; %create a symmetric matrix of ones and zeros 
D = triu(A); %capacity up to 100
Capacity = C.*round(100*(D + D')); % form symmetric matrix 

%Initialize flow structure
flows = repmat(struct('source', 0, 'sink', 0, 'startTime', 0, 'endTime', 0,'shPath',shPath, 'flowId', 0),1000,1);
networkPower = repmat(struct('power',0,'timeInterval',0),2000,1);
%Prepare UserData to use between timer callback functions
uData = struct('activeLinks', activeLinks, 'load', load, 'flows', flows, 'numberActiveFlows', numberActiveFlows, 'capacity', Capacity,'currentFlowNumber', currentFlowNumber);

startTime = 0; %time since the simulation started

arrivalTimeLast = 0; %last flow arrival time
arrivalTimeNow = 0;  %the current flow start time

eventTimetLast = 0;  % last time an event occurred
eventTimeNow = 0;    % the time at which the current event occured
eventsCount = 0;      % number of events that has already occured
totalEnergy = 0;

while(startTime < simulationTime),
    
    load = uData.load;
    flows = uData.flows;
    activeLinks = uData.activeLinks;
    
    %select links that are able to carry an additional flow with a given
    %data rate both on the active network and on the entire network
    available = triu((Capacity - load -flowRate)>0, -N);
    availableActive = available.*activeLinks;
    
    startDelay = exprnd(1/lambda);      % time to the start of the next flow
    startTime = startTime + startDelay; % starting time of the flow
    arrivalTimeLast = arrivalTimeNow;   % update the the last arrival time
    arrivalTimeNow = startTime;         % update the current arival time
    
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
        endingFlows = cell2struct(flowsCell,{'source', 'sink', 'startTime', 'endTime','shPath', 'flowId'},2);
        %handle finishing of ending of flows that end before the next flow
        %arrival time
        for i = 1:endingFlowsQuantity
            eventTimeLast = eventTimeNow;
            eventTimeNow = endingFlows(i).endTime;
             % schedule the flow finish time call flowFinishTimer.m
            flowFinish(flowRate, endingFlows(i).flowId);
            
            ntkPwr = ntkPower(uData, N);
            eventsCount = eventsCount + 1;
            
            networkPower(eventsCount).power = ntkPwr;
            networkPower(eventsCount).timeInterval = eventTimeNow - eventTimeLast;
            totalEnergy = totalEnergy + ntkPwr*(eventTimeNow - eventTimeLast);
        end
    end
        
    % The flowArrival.m function handles an incoming flow
    flowArrival(available, availableActive, flowRate, N, startTime, mu);
    eventTimeLast = eventTimeNow;
    eventTimeNow = startTime;
    ntkPwr = ntkPower(uData, N);
    eventsCount = eventsCount + 1;
    networkPower(eventsCount).power = ntkPwr;
    networkPower(eventsCount).timeInterval = eventTimeNow - eventTimeLast;
    totalEnergy = totalEnergy + ntkPwr*(eventTimeNow - eventTimeLast);
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
    endingFlows = cell2struct(flowsCell,{'source','sink','startTime','endTime','shPath','flowId'},2);
    for i = 1:endingFlowsQuantity
        eventTimeLast = eventTimeNow;
        eventTimeNow = endingFlows(i).endTime;
        % schedule the flow finish time call flowFinish.m
        %flowFinish(flowRate, endingFlows(i).flowId);

        ntkPwr = ntkPower(uData, N);
        eventsCount = eventsCount + 1;

        networkPower(eventsCount).power = ntkPwr;
        networkPower(eventsCount).timeInterval = eventTimeNow - eventTimeLast;
        totalEnergy = totalEnergy + ntkPwr*(eventTimeNow - eventTimeLast);
    end
end

averagePowerPerFlow  = (totalEnergy/eventTimeNow)/uData.currentFlowNumber;

%write the flow arrival rate and the average power per flow to a file
fp = fopen('Energy .txt','at');
fprintf(fp, '%d\t %f\n', lambda, averagePowerPerFlow);
fclose(fp);

