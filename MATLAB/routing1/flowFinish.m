function flowFinish(flowRate, flowId)
    
    uData = evalin('base','uData');%read uData structure from workspace
    shPath = uData.flows(flowId).shPath;
    load = uData.load;
    activeLinks = uData.activeLinks;
    numberActiveFlows = uData.numberActiveFlows;
    flows = uData.flows;
    
    %reset the flow with the given flow data
    flows(flowId).source = 0;
    flows(flowId).sink = 0;
    flows(flowId).startTime = 0;
    flows(flowId).endTime = 0;
    flows(flowId).shPath = zeros(1,13);

        
    pathlength = length(shPath); %get the path length of the flow's route   
    %update the load matrix
    for i=1:pathlength-1
        
        load(shPath(1,i),shPath(1,i+1)) = load(shPath(1,i),shPath(1,i+1)) - flowRate; 
        load(shPath(1,i+1),shPath(1,i)) = load(shPath(1,i+1),shPath(1,i)) - flowRate;
    end

    %update the actvNtk matrix
    for i=1:pathlength-1
        if(load(shPath(1,i),shPath(1,i+1)) == 0)
            activeLinks(shPath(1,i),shPath(1,i+1)) = 0;
            activeLinks(shPath(1,i+1),shPath(1,i)) = 0;
        end
    end
    
    %update uData and save it to the work space
    uData.flows(flowId) = [];
    uData.load = load;
    uData.activeLinks = activeLinks;
    uData.numberActiveFlows = numberActiveFlows - 1;
    uData.flows = flows;
    assignin('base','uData',uData); %write uData to workspace
end