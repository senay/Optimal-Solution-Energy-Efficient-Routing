N = 10; % size of square matrix
p = 0.5; % probability of 0s
A = round(10*rand(N)); % matrix of 0s and 1s (upper triangular part)
B = triu(A>p).*A; 

D = B + B'; % now it is symmetric