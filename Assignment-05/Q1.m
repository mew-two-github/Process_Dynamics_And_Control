clear; close all;
%% Setup the system
s = tf('s');
Gp = (s^2-4*s+8)/(s*(s+1)*(s+3));
G_sens = 1/(s+10);
L = Gp*G_sens;
%% Rootlocus plot
%rltool(L);
rlocus(L);
%% Solve for break in point
p = conv([4 42 86 30],[1 -4 8]) - conv([2 -4],[1 14 43 30 0]);
r = roots(p);
%% Part d)
Kcu = 4.69;
k = 0.01:0.01:Kcu;
r1 = zeros(length(k),1);
for i = 1:length(k)
    G = Gp*G_sens;
    sys = k(i)*G/(1+k(i)*G);
    S = stepinfo(sys);
    r1(i) = S.SettlingTime;
end
[val,loc] = min(r1);
Kc = k(loc);
%% Part e)
Lnew = tf([1 -4 8],([1 14 43 30 0 0]+Kc*[0 0 1 -4 8 0]));
figure;
rlocusplot(Lnew);
