%% Sensitivity function PI Controller
function So  = Q2_So(tauI,Kc,w)
    Gp = 2*(1j*w + 4)./(-10*w.^2+1+7*1j*w).*exp(-2j*w);
    Gc = Kc*(1+1/tauI./(1j*w));
    So = 1./(1+Gp.*Gc);
end