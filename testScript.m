
n = struct('z',3,'y',2,'x',1);

for i = 1:10  
    
    x = exprnd(0.5);
    t = timer;
    t.StartDelay = x;
    t.TimerFcn = {@testTimer};
    start(t);
    
    %delete(t);    
    %stop(t);
end
