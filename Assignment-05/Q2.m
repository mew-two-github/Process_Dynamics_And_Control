clear; close all;
%% Setup a P controller
Gp = tf([2 8],[10 7 1],'iodelay',2);
L = Gp;
[Gm,Pm,Wcg,Wcp] = margin(L);
margin(Gp);
Gm= 20*log10(Gm);
Gm_reqd = 8.2;
K_cu = 10^(Gm/20);
Kc = K_cu*10^((-Gm_reqd)/20);
[Gm2,Pm2,Wcg2,Wcp2] = margin(L*Kc);
%% Delay Uncertainity
w = Wcp2; % Here wcp and wcg correspond to Wgc, and Wpc respectively.
pm_verify = 180 + (atan(w/4)-atan(7*w/(1-10*w^2)) - 2*w)*180/pi;
figure;
margin(L*Kc);
DM = pm_verify/(w*180)*pi;
%% Designing a PI controller
s = tf('s');
[tauI,fval,exitflag]= fsolve(@(tauI) func(tauI,L,Kc),0.5);
figure;
margin(L*Kc*(1+1/tauI/s));
%% Evaluating the sensitivity integral
% P Controller
logmod2 = @(Kc,w) (log(abs(Q2_So2(Kc,w))));
int_val2 = integral(@(w)logmod2(Kc,w), 0, 10^5);
% PI controller
logmod = @(tauI,Kc,w) (log(abs(Q2_So(tauI,Kc,w))));
int_val = integral(@(w)logmod(tauI,Kc,w), 0, 10^4);
%% function that gives 60-PM for a given tau
function P  = func(tauI,L,Kc)
    s = tf('s');
    [~,PM,~,~] = margin(L*Kc*(1+1/tauI/s));
    P = 60 - PM;
end
