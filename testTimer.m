function [u] =  testTimer(obj,event)
  
   n = evalin('base','n')
   z = n.z;
   y = n.y;
   x = n.x;
   
   
   n.z = z + 1;
   n.y = y + 1;
   n.x = x + 1;
   
   assignin('base','n',n);
end