Y = [3 -1 -1; 1 -3 1; 1 1 -3];
I = [-1; -2; 1];
V = inv(Y)*I;
x=V(1);
y=V(2);
z=V(3);
fprintf('Result:\nV_{1}=%f \nV_{2}=%f \nV_{3}=%f',x,y,z);
%%
syms x
y1 = diff(tan(x)^3);
y2 = diff(2^x-5*x^3-9*exp(3*x^2));
y3 = diff(diff(x^4-5*x));
fprintf('Differentiation of tan(x)^3: %s\n',char(y1));
fprintf('Differentiation of 2^x-5*x^3-9*exp(3*x^2): %s\n',char(y2));
fprintf('Double Differentiation of x^4-5*x: %s\n',char(y3));

%%
syms x y a
a = x^2*sin(x)
Fa = int(a, x, 0, pi)
 
b = x*y + y^2
Fb = int(int(b, x, 0, 1), y, 0, 2)

c = exp(-x^2)*x
Fc = int(c, x, 0, inf)

e = sin(x)^3*cos(x)
Fe = int(e, x, 0, pi/2)

f = x*log(x)
Ff = int(f, x, 1,2)

g = 1/sqrt(1-x^2)
Fg = int(g, x, 0, 1/2)

h(x,y) = x^2 + x*y
Fh = int(h, x, 0, y)

i = exp(-a*x)*sin(x)
Fi = int(i, x, 0, inf)

j = 3*x^4 - 2*x^3 + 5*x^2 - x + 7
Fj = int(j, x, -1, 1)

k = exp(sin(x))*cos(x)
Fk = int(k, x, 0, pi)

%%
R = [26 -20 0; -16 41 -6; -4 -6 24];
V =[10; 5; 0];
I = inv(R)*V;
fprintf('The current supplied by the 10V source is %f\n',I(1));
P= (I(2)^2)*8;
fprintf('The power dissipated by 8 ohm is %f',P);