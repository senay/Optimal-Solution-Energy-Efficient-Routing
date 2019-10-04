set Nodes;
set Links within {Nodes, Nodes};

param demand {n in Nodes} default 0;
param capacity {(i, j) in Links} default 20000;
param power_node {i in Nodes} default 90;
param power_link {(i,j) in Links} default .0000075;

var flow {(i, j) in Links} >=0 <=capacity[i, j];
var activate_node {n in Nodes} binary ;
var activate_link {(i, j) in Links} binary ;

minimize total_power:
sum {(i, j) in Links} flow[i, j]*power_link[i, j]*activate_link[i, j]*2
+sum {i in Nodes} power_node[i]*activate_node[i]
;

subject to balance {n in Nodes}:
sum {x in Nodes: (x, n) in Links} flow[x, n] #incoming flow
-sum {y in Nodes: (n, y) in Links} flow[n, y] #outgoing flow
= demand[n] #demand or supply
;


subject to states {i in Nodes}:
sum {(x, i) in Links} activate_link[x, i]
+sum {(i, y) in Links} activate_link[i, y]
<=1000*activate_node[i]
;

subject to flowbound1 {(i, j) in Links}:
 flow[i, j] <= capacity[i, j]*activate_link[i, j]
;

