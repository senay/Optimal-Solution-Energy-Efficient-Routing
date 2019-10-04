function flowFinishTimer(obj, event, flowRate, currentFlowNumber)
    
    uData = evalin('base','uData');%read uData structure from workspace
    z = uData.flows(currentFlowNumber).shPath;
    load = uData.load;
    actvNtk = uData.actvNtk;
    numberActiveFlows = uData.numberActiveFlows;
    flows = uData.flows;
    
    %reset the flow with the given flow data
    flows(currentFlowNumber).source = 0;
    flows(currentFlowNumber).sink = 0;
    flows(currentFlowNumber).startTime = 0;
    flows(currentFlowNumber).duration = 0;
    flows(currentFlowNumber).shPath = zeros(1,13);

        
    pathlength = length(z); %get the path length of the flow's route   
    %update the load matrix
    for i=1:pathlength-1
        load(z(1,i),z(1,i+1)) = load(z(1,i),z(1,i+1)) - flowRate; 
        load(z(1,i+1),z(1,i)) = load(z(1,i+1),z(1,i)) - flowRate;
    end

    %update the actvNtk matrix
    for i=1:pathlength-1
        if(load(z(1,i),z(1,i+1)) == 0)
            actvNtk(z(1,i),z(1,i+1)) = 0;
            actvNtk(z(1,i+1),z(1,i)) = 0; 
        end
    end
    
    %update uData and save it to the work space
    uData.load = load;
    uData.actvNtk = actvNtk;
    uData.numberActiveFlows = numberActiveFlows - 1;
    uData.flows = flows;
    assignin('base','uData',uData); %write uData to workspace
end