clear;close all;
s = tf('s');
%% Given Data
Kv = 0.9; Kip = 0.75;
t = (0:1:11)';
T = ([12,12.5,13.4,14,14.8,15.4,16.1,16.4,16.8,16.9,17,16.9]'-12)/2;
plot(t,T);
% Can't see any inverse response, so mostly no zero assume first order plus
% time delay.
%% Model Estimation
[X,RESNORM,RESIDUAL,EXITFLAG] = lsqcurvefit(@resp,[5 2 1],t,T);
K = X(1)*Kv*Kip;
tau1  = X(2);
tau2 = X(3);
Gp = tf(K,conv([tau1 1],[tau2 1]));
%% Part a) IMC
tauc = max(tau1 ,tau2)/2;
Kc = (tau1 +tau2)/(K*tauc);
tauI = tau1 + tau2;
tauD = (tau1*tau2)/(tau1 + tau2);
Gc_imc = Kc*(1+1/(tauI*s)+tauD*s);
%% Part b) ITAE (setpoint)
% FOPTD approximation
D = tau2/2;
tau = tau1 + tau2/2;
% Use tables
AP = 0.965;
BP = -0.85;
Kc_b = AP*(D/tau)^BP/K;
AI = 0.796;
BI = -0.1465;
tauI_b = tau/(AI + BI*(D/tau));
AD = 0.308;
BD = 0.929;
tauD_b = AD*(D/tau)^BD*tau;
Gc_b = Kc_b*(1+1/(tauI_b*s)+tauD_b*s);
%% Part c) ITAE (disturbance)
AP = 1.357;
BP = -0.947;
Kc_c = AP*(D/tau)^BP/K;
AI = 0.842;
BI = -0.738;
tauI_c = tauI/(AI*(D/tau)^BI);
AD = 0.381;
BD = 0.995;
tauD_c = AD*(D/tau)^BD*tau;
Gc_c = Kc_c*(1+1/(tauI_c*s)+tauD_c*s);
%% Function to give step response for lsqcurvefit
function Y = resp(params,tvec)
    K = params(1);
    tau = params(2);
    tau2 = params(3);
    Gp = tf(K,conv([tau 1],[tau2 1]));
    Y = step(Gp,tvec);
end