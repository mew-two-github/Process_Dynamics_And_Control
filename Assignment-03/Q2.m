close all; clear;
G = tf([10 -40],[1 7 10],'InputDelay',3);
%% Part a)- Impulse and Step responses
% Impulse response
[Yimpulse,Timpulse] = impulse(G);
subplot(1,2,1);
% Yhand = 0*Yimpulse;
% ind = find(Timpulse>=3,1);
% Yhand(ind:end) = 30*exp(-5*(Timpulse(ind:end)-3))-20*exp(-2*(Timpulse(ind:end)-3));
plot(Timpulse,Yimpulse);%,Timpulse,Yhand,'r');
title('Impulse Response');
% Step response
[Ystep,Tstep] = step(G);
% Yhand2 = 0*Ystep;
% ind = find(Tstep>=3,1);
% Yhand2(ind:end) = 6*(1-exp(-5*(Tstep(ind:end)-3)))- 10*(1-exp(-2*(Tstep(ind:end)-3)));
subplot(1,2,2);
plot(Tstep,Ystep);%,Tstep,Yhand2);
title('Step Response');
%% Part b)-Response to the given sinusoidal input
Tmax = 75;
t = 0:0.01:Tmax;
U = 2*sin(5*t) + 3*cos(0.1*t);
Y = lsim(G,U,t);
yhand = 3.363*sin(5*t-17.87) + 11.9863*cos(0.1*t-0.3949);
figure();
plot(t,Y); title('Response to sinusoidal input');
xlabel('Time');ylabel('Output');
figure();
plot(t,Y,t,yhand,'r-.');
legend('Simulated','Approximated'); title('Response to sinusoidal input');
xlabel('Time');ylabel('Output');
%% Part c) Bode Plot
figure();
bode(G);
[MAG,PHASE,W] = bode(G);
%% Part d) MinPhase
G2 = tf([10 40],[1 7 10],'InputDelay',3);
[MAG2,PHASE2,W2] = bode(G2);
figure();
bode(G);
hold on;
bode(G2,'r-.');
legend('Old TF','Min Phase TF');