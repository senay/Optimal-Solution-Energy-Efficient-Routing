function routeOptimization(uData, N, mu, currenttTime,availableActive)
   
    Capacity = uData.capacity;
    activeLinks = uData.activeLinks;
    load = uData.load;
    flows =uData.flows;
    currentFlowNumber = uData.currentFlowNumber;
   
    for k = 1:currentFlowNumber
        %if flow k has source and destination nodes and it has been mu/2 seconds since it has sarted, 
        %check for possibility of rerouting the flow  
        if ((flows(k).source >0)&&(flows(k).sink > 0)&&(currenttTime - flows(k).startTime > mu/2))
            g = graph(availableActive);
            flowRate = flows(k).flowRate;
            newshPath = shortestpath(g,flows(k).source,flows(k).sink);
            lengthshPath = length(flows(k).shPath);
            lengthnewshPath = length(newshPath);
            reroutingPossible = 1;
            isSameEdge = 0;
            if (length(flows(k).shPath) > length(newshPath))
                for i = 1:lengthnewshPath-1
                    for j = 1:lengthshPath-1
                        if(findedge(g, newshPath(1,i),newshPath(1,i+1)) == findedge(g, flows(k).shPath(1,j),flows(k).shPath(1,j+1)))
                            isSameEdge = 1;
                            break;
                        end
                    end
                    if (isSameEdge == 0 && Capacity(newshPath(1,i),newshPath(1,i+1))-load(newshPath(1,i),newshPath(1,i+1)) - flowRate < 0)
                        reroutingPossible = 0;
                    end 
                end
            end
    
            if(reroutingPossible == 1)
                
                shPath = flows(k).shPath;
                flows(k).shPath = newshPath;%change the shortes path
                
                %check if any link from the new shortest path is also
                %old shortest path or not and update the load matrix
                %accordingly
                for i = 1:lengthnewshPath-1
                    for j = 1:lengthshPath-1
                        
                        if(findedge(g, newshPath(1,i),newshPath(1,i+1)) == findedge(g, shPath(1,j),shPath(1,j+1)))
                            isSameEdge = 1;
                            break;
                        end
                    end
                    %if this link is not also on the previous path update
                    %the load matrix by adding flow rate to the new link
                    if (isSameEdge == 0)
                        load(newshPath(1,i),newshPath(1,i+1)) =load(newshPath(1,i),newshPath(1,i+1)) + flowRate;                    
                        load(newshPath(1,i+1),newshPath(1,i)) =load(newshPath(1,i+1),newshPath(1,i)) + flowRate;
                        
                    end 
                    isSameEdge = 0;
                end
                
%                 %check if any link from the old shortest path is also
%                 %in the new shortest path or not and update the load matrix
%                 %accordingly
                for j = 1:lengthshPath-1
                    for i = 1:lengthnewshPath-1
                        if(findedge(g, newshPath(1,i),newshPath(1,i+1)) == findedge(g, shPath(1,j),shPath(1,j+1)))
                            isSameEdge = 1;
                            break;
                        end
                    end
                    %if this link is not also on the new path update
                    %the load matrix by subtracting flowRate from the old link
                    if (isSameEdge == 0)
                        
                        load(shPath(1,j),shPath(1,j+1)) = load(shPath(1,j),shPath(1,j+1)) - flowRate; 
                        load(shPath(1,j+1),shPath(1,j)) = load(shPath(1,j+1),shPath(1,j)) - flowRate; 
                    end 
                    isSameEdge = 0;
                
                end
            end
            %upDate actvNtk Matrix
            for i = 1:N
                for j = 1:N
                    if(load(i,j) == 0)
                        activeLinks(i,j) = 0;
                        activeLinks(j,i) = 0;
                    end
                end 
            end
        end
    end
    assignin('base','uData',uData);%write the updated uData to the workspace
end