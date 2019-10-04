function routeOptimization(Capacity, actvNtk, load, flows)

    for k = 1:100
        if (flows(k).source ~= flows(k).sink)
            g = graph(actvNtk);
            newshPath = shortestpath(g,flows(i).source,flows(i).sink);
            lengthshPath = length(flows.shPath);
            lengthnewshPath = length(newshPath);
            reroutingPossible = 1;
            isSameEdge = 0;
            if (isequal(flows(k).shPath, newshPath) == 0)
                for i = 1:lengthnewshPath-1
                    for j = 1:lengthshPath-1
                        if(findedges(g, newshPath(1,i),newshPath(1,i+1)) == findedges(g, flows(k).shPath(1,j),flows.shPath(1,j+1)))
                            isSameEdge = 1;
                            continue;
                        end
                    end
                    if (isSameEdge == 0 && Capacity(newshPath(1,i),newshPath(1,i+1))-load(newshPath(1,i),newshPath(1,i+1)) < 0)
                        reroutingPossible = 0;
                    end 
                end
            end
            
            if(reroutingPossible == 1)
            
                flows(k).shPath = newshPath;
                
                for i = 1:lengthnewshPath-1
                    for j = 1:lengthshPath-1
                        if(findedges(g, newshPath(1,i),newshPath(1,i+1)) == findedges(g, flows(k).shPath(1,j),flows.shPath(1,j+1)))
                            isSameEdge = 1;
                            continue;
                        end
                    end
                    if (isSameEdge == 0)
                        load(newshPath(1,i),newshPath(1,i+1)) =load(newshPath(1,i),newshPath(1,i+1)) + flowRate; 
                        load(flows(k).shPath(1,j),flows(k).shPath(1,j+1)) =load(flows(k).shPath(1,j),flows(k).shPath(1,j+1)) - flowRate; 
                    end 
                end
                
                
                for i = 1:n
                    for j = 1:n
                        
                        if(load(i,j)==0)
                        
                            actvNtk(i,j) = 0;
                            actvNtk(j,i) = 0;
                            
                        end
                        
                        
                    end 
                end
            end
        end
    end
end