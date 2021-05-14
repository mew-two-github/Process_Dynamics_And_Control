clear; close all;
%% Setup the system
s = tf('s');
Gp = 2*(s+2)/(s^2+2*s-3)*exp(-s);
Gp_pade = 2*(2-s)*(s+2)/(s^2+2*s-3)/(s+2);
%% rl plot for fun
%rlocusplot(sys)
% Kc = 0.76393 gives stable roots (from rltool
%% Plot the nyquist diagram
figure();
nyquist(Gp);
grid on;
hold on;
% Plot the unit circle
n = 500;
theta = linspace(0,2*pi,n);
x = cos(theta); y = sin(theta);
plot(x,y,'r-.')
hold off;
legend('Nyquist','Unit Circle');
w = 0.78; % From nyquist plot
GM = -0.767; % From Nyquist Plot
Kc1 = 10^(-10.5/20)/4*3; % Derived by hand
figure;nyquist(Kc1*Gp)
Kc2 = 10^((-0.767-10.5)/20);
figure;nyquist(Kc2*Gp);
