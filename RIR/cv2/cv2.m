%% 
% 1) Primy model
% 2) Prima funkce/LTI
% 3) Stavovy model
% 4) Stavovy model rozepsany
%
% mddy + bdy + ky = u
%
% dx = A*x + B*u
%  y = C*x + D*u, 
%
%  n = 2 ... pocet stavu   
% x_1 = y, dx_1 = dy
% x_2 = dx_1, dx_2 = ddy
% 
% dx_1      0     1     x_1      0
%      =             *       +
% dx_2   -k/m  -b/m     x_2     1/m
%
%              x_1
% y = [1  0] *      + 0
%              x_2
%
% Prenosová funkce
%
% y(s)/u(s) = 1/(ms^2 + bs + k)
%

clc
clear

b = 100;
k = 10000;
m = 10;

A = [   0    1;  
     -k/m -b/m];
B = [0; 1/m];

C = [1 ,0];
D = 0;


stateSpace = ss(A,B,C,D);
discreteStateSpace = c2d(stateSpace, 0.0001);









