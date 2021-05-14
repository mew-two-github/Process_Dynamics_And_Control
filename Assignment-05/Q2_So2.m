%% Sensitivity function P controller
function So  = Q2_So2(Kc,w)
    Gp = 2*(1j*w + 4)./(-10*w.^2+1+7*1j*w).*exp(-2j*w);
    Gc = Kc;
    So = 1./(1+Gp.*Gc);
end