function uData = flowArrival(obj,event, available, availableActv, flowRate, n)
    
    uData = evalin('base','uData');%read uData from workspacce
    s = randi(n,1,1); %source node
    d = randi(n,1,1); %destination node
    mu = 20;         %argument to exponential flow duration time.

    
    flowRouted = 0;
    
    if(s ~= d) %check if the source node is different from the destination node
       
        actvNtk = uData.actvNtk;
        load = uData.load;
        flows = uData.flows;
        currentFlowNumber = uData.currentFlowNumber;
        numberActiveFlows =uData.numberActiveFlows;
               
        currentFlowNumber = currentFlowNumber + 1; % the assigned number to the current flow

        g = graph(availableActv);
        zz = shortestpath(g,s,d);%find the shortest path on the active network
        pathlength = length(zz);

        %if path found on the active network update the load matrix
        if pathlength > 0            
            for i=1:pathlength-1 %number of links is one less than number of nodes
                load(zz(1,i),zz(1,i+1)) = load(zz(1,i),zz(1,i+1)) + flowRate;
                load(zz(1,i+1),zz(1,i)) = load(zz(1,i+1),zz(1,i)) + flowRate;
            end  
            flowRouted = 1;
        else%if path not found on the actvie network find a path on the available network
            g=graph(available);
            zz = shortestpath(g,s,d);%find the shortest path on the avaiable network
            pathlength = length(zz);
            
            %if there is a suitable path on the obtained form the available
            %network update the load matix and the active network matrix
            if pathlength > 0
                for i=1:pathlength-1 % number of links is one less than number of nodes
                    load(zz(1,i),zz(1,i+1)) = load(zz(1,i),zz(1,i+1)) + flowRate;                
                    load(zz(1,i+1),zz(1,i)) = load(zz(1,i+1),zz(1,i)) + flowRate;
                    if(actvNtk(zz(1,i), zz(1,i+1)) == 0), 
                        actvNtk(zz(1,i), zz(1,i+1)) = 1;
                        actvNtk(zz(1,i+1), zz(1,i)) = 1;
                    end
                end
                
                flowRouted = 1; %indicates the flow is routed(assigned a path)
                routeOptimization(uData,flowRate,n);%run the route optimization since the active network has changed
            end  
        end
        
        if (flowRouted == 1)%if the current flow is assigned a path
            
            duration = exprnd(mu);% duration of the flow
            %create timer object to schedule flow finish time
            tt = timer;
            tt.StartDelay = duration; %time to finish the flow

            %tt.StartFcn = @(x,y)disp('');
            %tt.StopFcn = @(x,y)disp('');

            %schedule the flow's finish time.
            %This is handled by the flowFinishTimer.m function
            tt.TimerFcn = {@flowFinishTimer, flowRate, currentFlowNumber};
            start(tt);        
       
            %save the current flow and its variables to the flows structure
            flows(currentFlowNumber).source = s;
            flows(currentFlowNumber).sink = d;
            flows(currentFlowNumber).startTime = now*24*3600;
            flows(currentFlowNumber).duration = duration;
            flows(currentFlowNumber).shPath = zz;

            %Update the uData structure and save it to the workspace
            uData.actvNtk = actvNtk;
            uData.load = load;
            uData.flows = flows;
            uData.currentFlowNumber = currentFlowNumber;
            uData.numberActiveFlows = numberActiveFlows + 1;
            assignin('base','uData',uData); 

        end 
    end
   
end