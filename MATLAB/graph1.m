Capacity(1:13, 1:13) = 0;
actvNtk(1:13, 1:13) = 0;
load(1:13, 1:13) = 0;
for i = 1:13
    for j = 1:13
        linkProb = rand;
        if linkProb > 0.5 && i ~= j
            
            edgeWeight =randi(50,1,1);
            Capacity(i,j) = edgeWeight;
            Capacity(j,i) = edgeWeight;
        end
      
    end
end

t = timer('ExecutionMode', 'fixedRate','TasksToExecute', 2, 'Period', 3, 'StartDelay', 3);
t.StartFcn = @(x,y)disp('Started.');
t.TimerFcn = {@pathComputation, actvNtk, load, Capacity};
t.StopFcn = @(x,y)disp('stopped.');
t.UserData.actvNtk;
start(t);
%delete(t);