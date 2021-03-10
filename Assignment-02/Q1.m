clear; close all;
%% Part b) Find steady-state and linearise
open_system('Q1_model')
% Read the operating conditions into an object
opc = operspec('Q1_model');
% Operating conditions
opc.Inputs.u = 0.8;
opc.Inputs.Known = 1;
% Constraints
%opc.States(1).Min = 0;opc.States(2).Min = 0;
%opc.States(1).Max = 0.8;
% Find the steady state point
ss_point = findop('Q1_model',opc);
% Linearize 
linsys = linearize('Q1_model',ss_point); %Using lin mod: linmod('Q3_model',x_ss,[80 100])
[NUM, DEN] = ss2tf(linsys.A,linsys.B,linsys.C,linsys.D);
NUM = {NUM(1,:) NUM(2,:)};
G = tf(NUM,DEN);
%% Hand calculations
Css=ss_point.States(1).x;
Tss=ss_point.States(2).x;
Ti = 549.67;
Cp = 0.8;
pho = 52;
delta_Hr = -500*10^3;
V = 1200;
Fi = 20;
alpha = 2.4*10^15;
beta = 2*10^4;
Cp = 1.05506*10^3*0.8; % Converted to kJ/lb
CAiss = 0.8;
Tinit = 559;
CAinit = 0.0193;
A =  zeros(2);
A(1,:) = [-(Fi/V + alpha*exp(-beta/Tss))  -alpha*exp(-beta/Tss)*beta/Tss^2*Css];
A(2,:) = [-delta_Hr/(pho*Cp)*alpha*exp(-beta/Tss) -delta_Hr/(pho*Cp)*alpha*exp(-beta/Tss)*beta/Tss^2*Css-Fi/V];
B = [Fi/V;0];
C = eye(2);
%% Part d): Computing response
% Since linear system, changes in input and output are proportional
[Y,T,X]=step(linsys);
figure();
subplot(2,1,1);plot(T,Y(:,1)*0.1*0.8+Css); title('C variation, step 10%');
grid on; grid minor;
subplot(2,1,2);plot(T,Y(:,2)*0.1*0.8+Tss); title('T variation, step 10%');
grid on; grid minor;
%% Part e): Comparing gains
Gain_T = 0.4663/0.08;
Gain_C = (0.2-0.0193)/0.08;