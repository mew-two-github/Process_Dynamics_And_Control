clear; close all;
%% Setup the system
s = tf('s');
Gp = 2*(s+2)/(s^2+2*s-3)*exp(-s);
%% 3a
Gp_pade = 2*(2-s)/(s^2+2*s-3);
f = @(s)(2*(2-s)/(s^2+2*s-3));
Kc_a = -1/(f(-0.2));
poles_parta = pole(1/(1+Kc_a*Gp_pade))
%% 3c
Gp_pade_second = 2*(s+2)*(1-s/2+s^2/8)/((s^2+2*s-3)*((1+s/2+s^2/8)));
rltool(Gp_pade_second)
%0.7878