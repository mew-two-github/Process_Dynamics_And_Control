clear;close all;
%% Part a)
A1 = [-3 0 0;0 -5 0;0 0 -2];
B1 = [1;-2/3;-1/3];
C1 = [1 1 1];
model1 = ss(A1,B1,C1,0);
[NUM,DEN] = ss2tf(A1,B1,C1,0);
G1 = tf(NUM,DEN);
A2 = [0 0 -30;1 0 -31;0 1 -10];
B2 = [1;1;0];
C2=[0 0 1];
model2=ss(A2,B2,C2,0);
[NUM,DEN] = ss2tf(A2,B2,C2,0);
G2 = tf(NUM,DEN);
% Diagonalise A2 to get A1
[V,D] = eig(A2);
Vnew = V(:,[2,3,1])
T = inv(Vnew);
%% Part b)
A = [-1 0 0;0 -2 0;0 0 -3];
B = [1;1;1];
C = [-3/2 0 11/2;0 -20 30];
r1 = rank(obsv(A,C));
r2 = rank(ctrb(A,B));