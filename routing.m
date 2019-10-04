n = 13; %number of nodes
Capacity(1:n, 1:n) = 0;
actvNtk(1:n, 1:n) = 0;
load(1:n, 1:n) = 0;
available(1:n, 1:n) = 0;
availableActv(1:n, 1:n) = 0;
shPath = zeros(1,13);
secondsInADay = 24 * 3600; % number of seconds in a day
flowcnt = 0; % number of active flows

flowRate = 6; % packet arrival rate of a flow 
startingTime = datenum(datetime('now'))*secondsInADay;%simulation starting time

for i = 1:n
    for j = 1:n
        linkProb = rand;
        if linkProb > 0.5 && i ~= j
            edgeWeight =randi(50,1,1);
            Capacity(i,j) = edgeWeight;
            Capacity(j,i) = edgeWeight;
            available(i,j) = 1;
            available(j,i) = 1;
        end
    end
end

for i = 1:n
    for j = 1:n
        if (Capacity(i,j) - load(i,j) - flowRate < 0); 
            available(i,j) = 0;
            available(j,i) = 0;
        else
            available(i,j) = 1;
            available(j,i) = 1;            
        end
        if(actvNtk(i,j)==1 && available(i,j) == 1)
            availableActv(i,j) = 1;
        end
    end
end

%Initialize flow structure
flow1 = repmat(struct('source', 0, 'sink', 0, 'startTime', 0, 'duration', 0,'shPath',shPath),100,1);

%Prepare UserData
uData = struct('actvNtk', actvNtk, 'load', load, 'flow1', flow1, 'flowcnt1', flowcnt);

t = timer;
t.StartFcn = @(x,y)disp('');
t.StopFcn = @(x,y)disp('');
set(t, 'UserData', uData);
while(datenum(datetime('now'))*secondsInADay - startingTime < 2),

    t.TimerFcn = {@flowArrival,available,availableActv, flowRate, n};
    start(t);
    uData = get(t,'UserData');
end