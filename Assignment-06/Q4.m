model = 'mixing_vessel';
load_system(model);
out = sim(model);
y = out.simout.data;
t = out.tout;
iae = trapz(t,abs(y));