clear;close all;
%% System charecterstics
Lss = 80; Vss = 100;
M = 20; a=0.5; zf = 0.1;
%% Part a) Finding steady state (by hand)
% Equate derivatives to zero, solve the linear eqn
Ass = [-(a*Vss+Lss)/M Vss*a/M;Lss/M -(a*Vss+Lss)/M];
bss = [0;-Vss*zf/M];
x_ss = inv(Ass)*bss;
%% Part b) Linearisation (by Taylor Expansion)
w_ss = x_ss(1);z_ss=x_ss(2);
A = [-(Vss*a+Lss)/M Vss*a/M;Lss/M -(Lss+Vss*a)/M];
B = [-w_ss/M (-a*w_ss+a*z_ss)/M;(w_ss-z_ss)/M -a*z_ss/M+zf/M];
%% Part c) Finding the eigenvalues-eignvectors of the system
[V,D] = eig(A);
% Second eigen value is faster (more negative)
%% Part d) Find steady-state and linearise
open_system('Q3_model')
% Read the operating conditions into an object
opc = operspec('Q3_model');
% Operating conditions
opc.Inputs(1).u = 80;
opc.Inputs(2).u = 100;
opc.Inputs(1).Known = 1;
opc.Inputs(2).Known = 1;
% Constraints
opc.States(1).Min = 0;opc.States(2).Min = 0;
% Find the steady state point
ss_point = findop('Q3_model',opc);
% Linearize 
linsys = linearize('Q3_model',ss_point) %Using lin mod: linmod('Q3_model',x_ss,[80 100])
%% Part e) Give step changes and plot
% Done in SIMULINK. Use the manual switch to step input(s)
[Y,T,X]=step(linsys);
% Y(:,:,1) contains responses for change in L
% Since linear system, changes in input and output are proportional
figure();
subplot(2,1,1);plot(T,Y(:,1,1)*.05*Lss+w_ss); title('w variation, step 0.05');
subplot(2,1,2);plot(T,Y(:,2,1)*.05*Lss+z_ss); title('z variation, step 0.05');
figure();
subplot(2,1,1);plot(T,Y(:,1,1)*.15*Lss+w_ss); title('w variation, step 0.15');
subplot(2,1,2);plot(T,Y(:,2,1)*.15*Lss+z_ss); title('z variation, step 0.15');