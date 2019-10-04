function uData = flowArrival(obj,event, available, availableActv, flowRate, n)
    
    s = randi(n,1,1); %source node
    d = randi(n,1,1); %destination node
    
    if(s ~= d) %check if the source node is different from the destination node
        
        uData = get(obj,'UserData');

        t = timer;
        t.StartFcn = @(x,y)disp('');
        t.StopFcn = @(x,y)disp('');
        
        actvNtk = uData.actvNtk;
        load = uData.load;
        flow1 = uData.flow1;
        flowcnt = uData.flowcnt1;        
        
        flowcnt = flowcnt + 1;

        g = graph(availableActv);
        zz = shortestpath(g,s,d);
        pathlength = length(zz);

        if pathlength > 0
            for i=1:pathlength-1 %number of links is one less than number of nodes
                load(zz(1,i),zz(1,i+1)) = load(zz(1,i),zz(1,i+1)) + flowRate;
                load(zz(1,i+1),zz(1,i)) = load(zz(1,i+1),zz(1,i)) + flowRate;
            end        
            t.TimerFcn = {@flowFinishTimer, flowRate, flowcnt};
            start(t);
        else
            g=graph(available);
            zz = shortestpath(g,s,d);
            pathlength = length(zz);
            if pathlength > 0
                for i=1:pathlength-1 % number of links is one less than number of nodes
                    load(zz(1,i),zz(1,i+1)) = load(zz(1,i),zz(1,i+1)) + flowRate;                
                    load(zz(1,i+1),zz(1,i)) = load(zz(1,i+1),zz(1,i)) + flowRate;
                    if(actvNtk(zz(1,i), zz(1,i+1)) == 0), 
                        actvNtk(zz(1,i), zz(1,i+1)) = 1;
                        actvNtk(zz(1,i+1), zz(1,i)) = 1;

                        newlinks(zz(1,i), zz(1,i+1)) = 1;
                        newlinks(zz(1,i+1), zz(1,i)) = 1;

                    end
                end
                t.TimerFcn = {@flowFinishTimer, flowRate, flowcnt};
                start(t);
            end  
        end
        
        flow1(flowcnt).source = s;
        flow1(flowcnt).sink = d;
        flow1(flowcnt).startTime = now;
        flow1(flowcnt).duration = duration;
        flow1(flowcnt).shPath = zz;
        
        uData.actvNtk = actvNtk;
        uData.load = load;
        uData.flow1 = flow1;
        uData.flowcnt1 = flowcnt;
        assignin('base','uData',uData);
        set(obj,'UserData',uData);
        set(t,'UserData',uData);
    end
end