function uData = flowArrival(available, availableActive, flowRate, N, currentTime, mu, eventTimeNow)
    
    uData = evalin('base','uData'); %read uData from workspacce
    s = randi(N,1,1);
    d = randi(N,1,1);               %destination node
    while(s == d),                  % choose d different from s
        d = randi(N,1,1);
    end
    flowRouted = 0;   %indicates if a flow has been successfully routed

    activeLinks = uData.activeLinks;
    load = uData.load;
    flows = uData.flows;
    demand = uData.demand;
    %currentTime = uData.currentTime;
    currentFlowNumber = uData.currentFlowNumber + 1;
    numberActiveFlows =uData.numberActiveFlows;

    g = graph(availableActive);
    
    shPath = shortestpath(g,s,d);%find the shortest path on the active network
    pathlength = length(shPath);

    %if path found on the active network update the load matrix
    if pathlength > 0            
        for i=1:pathlength-1 %number of links is one less than number of nodes
            load(shPath(1,i),shPath(1,i+1)) = load(shPath(1,i),shPath(1,i+1)) + flowRate;
            load(shPath(1,i+1),shPath(1,i)) = load(shPath(1,i+1),shPath(1,i)) + flowRate;
        end  
        flowRouted = 1;
    else%if path not found on the actvie network find a path on the available network
        g=graph(available);
        shPath = shortestpath(g,s,d);%find the shortest path on the avaiable network
        pathlength = length(shPath);

        %if there is a suitable path obtained form the available
        %network update the load matix and the active network matrix
        if pathlength > 0
            for i=1:pathlength-1 % number of links is one less than number of nodes
                load(shPath(1,i),shPath(1,i+1)) = load(shPath(1,i),shPath(1,i+1)) + flowRate;                
                load(shPath(1,i+1),shPath(1,i)) = load(shPath(1,i+1),shPath(1,i)) + flowRate;
                if(activeLinks(shPath(1,i), shPath(1,i+1)) == 0), 
                    activeLinks(shPath(1,i), shPath(1,i+1)) = 1;
                    activeLinks(shPath(1,i+1), shPath(1,i)) = 1;
                end
            end

            flowRouted = 1; %indicates the flow is routed(assigned a path)
            routeOptimization(uData,N, mu, currentTime, availableActive);%run the route optimization when links are added to the active network
        end  
    end
    if (flowRouted == 1)%if the current flow is assigned a path
        demand(s,d) = demand(s,d) + flowRate;%update demand matrix
             
              
        duration = exprnd(mu);% duration of the flow

        %save the current flow and its variables to the flows structure
        flows(currentFlowNumber).source = s;
        flows(currentFlowNumber).sink = d;
        flows(currentFlowNumber).startTime = currentTime;
        flows(currentFlowNumber).endTime = currentTime + duration;
        flows(currentFlowNumber).shPath = shPath;
        flows(currentFlowNumber).flowId = currentFlowNumber;
        flows(currentFlowNumber).flowRate = flowRate;

        %Update the uData structure and save it to the workspace
        uData.activeLinks = activeLinks;
        uData.load = load;
        uData.flows = flows;
        uData.currentFlowNumber = currentFlowNumber;
        uData.numberActiveFlows = numberActiveFlows + 1;
        uData.demand = demand;
        assignin('base','uData',uData); 
    end    
end