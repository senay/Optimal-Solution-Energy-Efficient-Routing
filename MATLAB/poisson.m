lambda = 1; % arrival rate
Tmax = 10; % maximum time
T(1,1:100) = 0;
clear T;
T(1) = random('Exponential',1/lambda);
while(T(1,i) < Tmax),
    T(i+1) = T(i) + random('Exponential', 1/lambda);
    i = i+1;
end

T(i) = Tmax;
stairs(T(1:i), 0:(i-1));