function [X] = pathComputation(obj, event, actvNtk, load, capacity)
disp('Working!');
g = graph(actvNtk);
x = randi(12,1,1);
y = randi(12,1,1);
flowrate = randi(25,1,1);
%X = get(obj, 'UserData');
if(x ~= y)
    z = shortestpath(g,x,y);
    pathlength = length(z);
    if pathlength > 0
        for i=1:size(y)-1
            load(z(1,i),z(1,i+1)) = load(z(1,i),z(1,i+1)) + flowrate;            
        end
        plot(g);
    else
        g=graph(capacity-load);
        z=shortestpath(g,x,y);
        pathlength = length(z)
        if pathlength > 0
            for i=1:pathlength-1
                load(z(1,i),z(1,i+1)) = load(z(1,i),z(1,i+1)) + flowrate;
                actvNtk(z(1,i), z(1,i+1)) = 1;
                actvNtk(z(1,i+1), z(1,i)) = 1;
                




            end
            plot(g);
        end 

    end
end
set(obj,'UserData',actvNtk);
set(obj,'UserData',load);