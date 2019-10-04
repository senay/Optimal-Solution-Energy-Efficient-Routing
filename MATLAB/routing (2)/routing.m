n = 13;                          %number of nodes
Capacity(1:n, 1:n) = 0;          %bandwidth of links
actvNtk(1:n, 1:n) = 0;           %current active network
load(1:n, 1:n) = 0;              %load on the current active network
available(1:n, 1:n) = 0;         %links available on the entire network for routing carying 
                                 %additional traffic with a given flow rate 
availableActv(1:n, 1:n) = 0;     %links available on the active network for routing carying 
                                 %additional traffic with a given flow rate 
shPath = zeros(1,13);            %shortest path to be selected for a flow
flowRouted = 0;                  % indicates if a flow has been assigned a path successfully
secondsInADay = 24 * 3600;       % number of seconds in a day
numberActiveFlows = 0;           % number of active flows
currentFlowNumber = 0;           % the last flow number

flowRate = 2;                    % packet arrival rate of a flow in the order of K(1000)
startingTime = now*secondsInADay;%simulation starting time

lambda = 5;                      % flow arrival rate,
simulationTime = 500;            %simulation time in seconds

%bring s link up between any two nodes with probability 0.5 and indicate
%its availability for carrying traffic
for i = 1:n
    for j = 1:n
        linkProb = rand; % probability of connecting nodes i and j
        if linkProb > 0.5 && i ~= j
            edgeWeight =randi(50,1,1); % link bandwidth
            Capacity(i,j) = edgeWeight;
            Capacity(j,i) = edgeWeight;
            available(i,j) = 1;
            available(j,i) = 1;
        end
    end
end


%Initialize flow structure
flows = repmat(struct('source', 0, 'sink', 0, 'startTime', 0, 'duration', 0,'shPath',shPath),1000,1);

%Prepare UserData to use between timer callback functions
uData = struct('actvNtk', actvNtk, 'load', load, 'flows', flows, 'numberActiveFlows', numberActiveFlows, 'capacity', Capacity,'currentFlowNumber', currentFlowNumber);


timeSpan = 0; %time since the simulation started
while(timeSpan < simulationTime),
    
    load = uData.load;
    actvNtk = uData.actvNtk;
    %select links that are able to carry an additional flow with a given
    %data rate both on the active network and on the entire network
    for i = 1:n
        for j = 1:n
            if (Capacity(i,j) - load(i,j) - flowRate < 0); 
                available(i,j) = 0;
                %available(j,i) = 0;
            else
                available(i,j) = 1;
                %available(j,i) = 1;            
            end
            if(actvNtk(i,j)==1 && available(i,j) == 1)
                availableActv(i,j) = 1;
            end
        end
    end
    
    startDelay = exprnd(1/lambda); % time to the start of the next flow
    timeSpan = timeSpan + startDelay;
    t = timer; % create a timer object to schedule a flow 
    t.StartDelay = startDelay; % start the flow after startDelay seconds
    
    %t.StartFcn = @(x,y)disp('');
    %t.StopFcn = @(x,y)disp('');
    % call the call back function of a timer to start the flow. The
    % flowArrival.m function handles an incoming flow
    
    t.TimerFcn = {@flowArrival,available,availableActv, flowRate, n};
    start(t); % start the timer
    
       
end
ntkPower(uData, n,lambda);