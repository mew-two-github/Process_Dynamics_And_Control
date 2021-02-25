x1 = 1;x2 = 1;
Xsol = fsolve(@eqns,[x1;x2]);
function f = eqns(x)
    x1 = x(1);
    x2 = x(2);
    f(1) = x1.^2 + x1.*x2 - x2 - 10;
    f(2) = x2.^2 + x1.*x2 - x1 - 5;
end