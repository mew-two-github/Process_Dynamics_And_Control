clear; close all;
%% Simulating the actual process
G = tf([2 1],conv(conv(conv([20,1],[15,1]),[4 1]),[0.5 1]),'InputDelay',3);
t = 0:0.5:150;
[Yactual,Tactual] = step(G,t);
yfinal = 1;
%% Krishnaswamy and Sundaresan's method
[val,loc]= min(abs(Yactual-yfinal*0.3531));
t1 = Tactual(loc);
[val2,loc2] = min(abs(Yactual-yfinal*0.8531));
t2 = Tactual(loc2);
Dks = 1.3*t1 - 0.29*t2;
tauks = 0.67*(t2-t1);
G_ks = tf(1,[tauks 1],'InputDelay',Dks);
[Yks,Tks] = step(G_ks,t);
%% Skogestad's half rule method
% FOPTD
tau_s = 27.5; D_s = 13;
G_sk1 = tf(1,[tau_s 1],'InputDelay',D_s);
[Ysk1,Tsk1] = step(G_sk1,t);
% SOPTD
tau_1= 20; tau_2 = 17; D_s2 = 3.5;
G_sk2 = tf(1,conv([tau_1 1],[tau_2 1]),'InputDelay',D_s2);
[Ysk2,Tsk2] = step(G_sk2,t);
%% Least Squares (Frequency Domain)
[MAG,PHASE,W] = bode(G);
mpar = lsqcurvefit(@(mpar,wdata) magpred(mpar,wdata),[1 1 1]',W,squeeze(MAG));
Kp = mpar(1); tau1 = mpar(2); tau2 = mpar(3);
Delay = lsqcurvefit(@(D,wdata) phasepred(D,wdata,Kp,tau1,tau2),1,W,cos(squeeze(PHASE)));
Glsq = tf(Kp,conv([tau1 1],[tau2 1]),'InputDelay',Delay);
[Ylsq,Tlsq] = step(Glsq,t);
%% Compare step responses
% K&S
figure();
plot(Tactual,Yactual,Tks,Yks); xlabel('Time'); ylabel('Response');
title('Krishnaswamy and Sundaresan');
legend('Actual Response','K&S FOPTD approx');
% Half Rule
figure();
title("Skogestad's Half Rule");
subplot(2,1,1);
plot(Tactual,Yactual,Tsk1,Ysk1); xlabel('Time'); ylabel('Response');
legend('Actual Response','FOPTD approx');
subplot(2,1,2);
plot(Tactual,Yactual,Tsk2,Ysk2); xlabel('Time'); ylabel('Response');
legend('Actual Response','SOPTD approx');
% Least Squares in Frequency Domain
figure();
plot(Tactual,Yactual,Tlsq,Ylsq); xlabel('Time'); ylabel('Response');
title('Least Squares Fit');
legend('Actual Response','LSQ SOPTD Approx');
%% Functions for least squares fit
function Mag = magpred(mpar,wdata)
    Kp = mpar(1); tau1 = mpar(2);tau2 = mpar(3);
    Mag = Kp./sqrt(1+(tau1.*wdata).^2)./sqrt(1+(tau2.*wdata).^2);
end
function Phase = phasepred(D,wdata,Kp,tau1,tau2)
    Gw = Kp./(1+tau1*(1j*wdata))./(1+tau2*(1j*wdata));
    Phase = cos(phase(Gw)-D*wdata);
end