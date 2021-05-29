clear; close all;
tc = 5;
s = tf('s');
Gp = tf(1.15,[50 15 1]);
Gm = tf(1,[50 15 1]);
% PID controller
Gc  = tf([50 15 1],[tc 0]);
% Disturbance tf
Gd = tf(1,[5 1]);
lambdavec = 0.001:0.001:0.5;
r1 = ones(length(lambdavec),1);
r2 = r1;
for k = 1:length(lambdavec)
    % Feedforward controller
    Gff = -Gd*1/(lambdavec(k)*s+1)/Gp;
    % sys is Y/Do
    sys = (Gff*Gp+Gd)/(1+Gp*Gc);
    S = stepinfo(sys);
    % get settling time as close as possible to 15
    r2(k) = S.SettlingTime;
    r1(k) = abs(S.SettlingTime-15);
end
[val,loc] = min(r1);
lambda = lambdavec(loc);