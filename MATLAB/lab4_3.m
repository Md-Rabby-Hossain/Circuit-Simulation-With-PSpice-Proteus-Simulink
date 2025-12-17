hold on;
x=linspace(0, 4*pi, 100);
y = sin(x);

plot(y, 'ro-');
%title('Graph of sin(x)');
%xlabel('x');
%ylabel('sin(x)');


y1 = exp(-x/3);
plot(y1, 'g-');

y2 = y.*y1;
plot(y2, 'b-');
