R = [40 -10 -30; -10 30 -5; -30 -5 65];
V = [10; 0; 0];

I = inv(R)*V;

fprintf('The currenet through R is %f\n', I(3)-I(2));

p = 10* I(1);
fprintf('the power by the source is %f',p)

%%
syms x
diff(cos(2*x))
diff(diff(cot(x)))

%%
expr = -2*x/(1+x^2)^2;
%int(expr)
int(expr, 0,1)
%%

y = tan(x);
int(y, -pi/6, pi/2.3)