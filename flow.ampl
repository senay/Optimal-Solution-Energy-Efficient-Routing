set Nodes;
set Links within {Nodes, Nodes};

param demand {n in Nodes} default 0;
param capacity {(i, j) in Links};
param cost {(i, j) in Links};

var flow {(i, j) in Links} >=0 <=capacity[i, j];

minimize total_cost:
sum {(i, j) in Links} flow[i, j]*cost[i, j]
;

subject to balance {n in Nodes}:
sum {x in Nodes: (x, n) in Links} flow[x, n] #incoming flow
-sum {y in Nodes: (n, y) in Links} flow[n, y] #outgoing flow
= demand[n] #demand or supply
;
