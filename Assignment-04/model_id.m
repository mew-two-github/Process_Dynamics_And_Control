clear; close all;
Ts = 0.8; 
N = 2555;
%% Getting the data and splitting to train and test
open_system('model');
out = sim('model');
% Get the input and output
tk = out.ymeas.time;
uk = out.inputs.Data;
yk = out.ymeas.Data;
% Splitting the data: 60% train, rest 40% test
% tf is always in terms of deviation variables so we dont need to do any
% additional processing
ntrain = 0.6*N;
dataset = iddata(yk,uk,Ts);
train_data = dataset(1:ntrain);
test_data = dataset(ntrain+1:end);
%% Non parametric estimation
options = impulseestOptions;
options.Advanced.AROrder = 0;
fir_model = impulseest(train_data ,options);
[Y,T] = impulse(fir_model);
figure;
impulse(fir_model);
figure;
step(fir_model);
%% Parametric Estimation
d = 4;
% One zero because of inverse response
nb = 1;
% Looks overdamped so second order but can also be first. Trying both
nf1 = 1; nf2 = 2;
% First 4 responses are negligible
nk = 5;
oe_model1 = oe(train_data,[nb nf1 nk]);
figure;
resid(oe_model1,train_data);
oe_model2 = oe(train_data,[nb nf2 nk]);
figure;
resid(oe_model2,train_data);
% nf = 2 is not an underfit
% Check for overfit
present(oe_model2);
%% Cross Validation
figure;
compare(oe_model2,test_data);
figure;
step(oe_model2);
% Gains 3.96 and 4.03