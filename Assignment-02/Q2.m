clear; close all;
Kp1 = 1; tau1 = 4; Kp2 = 4; tau2 = 10; Cv1 = 3; A0 = 2; w0 = 3;
%% Declare tf objects and find G12
G1s = tf(Kp1,[tau1 1]);
G2s = tf(Kp2,[tau2 1]);
G12s = Cv1*G1s*G2s;
%% Identify poles and gain
poles12 = pole(G12s);
gain12 = dcgain(G12s);
%% Check the output for the perturbation
T = 2*pi/w0; % Time period of the oscillations
t = 0:0.01:T*30; % Monitor output for multiple time periods
u = A0*sin(w0*t); %  A sinusoidal input
Y = lsim(G12s,u,t);
plot(t,Y);
% Settles for a sine-wave output in the long run
% Amplitude
[~,ind1] = min(abs(28*T-t));
[~,ind2] = min(abs(30*T-t));
A_level = max(Y(ind1:ind2));
oscillh2 = 1;
if A_level < A0/10
    oscillh2 = 0;
end
%% TF approximation
[Y,T,X] = step(G12s);
plot(T,Y);
Kp = gain12; %Kp is steady state value of Y
[~,ind] = min(abs(Y-Kp*0.632));
tau = T(ind); % Tau is time when 63% of output is reached
G12approx = tf(Kp,[tau 1]);